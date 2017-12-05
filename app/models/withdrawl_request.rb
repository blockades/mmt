class WithdrawlRequest < ApplicationRecord
  belongs_to :member
  belongs_to :coin
  belongs_to :system_transaction

  [:last_changed_by, :in_progress_by, :confirmed_by, :completed_by, :cancelled_by].each do |reference|
    belongs_to reference, class_name: 'Member', foreign_key: "#{reference}_id".to_sym
  end

  STATES = %w(pending in_progress confirmed completed cancelled failed).freeze

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  validates :state, presence: true, inclusion: { in: STATES }

  scope :pending, -> { where state: :pending }
  scope :in_progress, -> { where state: :in_progress }
  scope :confirmed, -> { where state: :confirmed }
  scope :completed, -> { where state: :completed }
  scope :cancelled, -> { where state: :cancelled }
  scope :outstanding, -> { where.not state: [:confirmed, :completed, :cancelled] }

  state_machine :state, initial: :pending do
    event(:progress) { transition pending: :in_progress }
    event(:cancel)   { transition pending: :cancelled }
    event(:confirm)  { transition [:pending, :in_progress] => :confirmed }
    event(:complete) { transition confirmed: :completed }
    event(:fail)    { transition any: :failed }
    event(:retry)    { transition failed: :confirm }

    after_transition on: :confirm, do: :finalise!

    def initialize
      super
    end
  end

  def read_quantity
    quantity.to_d / 10**coin.subdivision
  end

  def confirm!(last_changed_by:)
    return false unless can_confirm?

    ActiveRecord::Base.transaction do
      update!(last_changed_by: last_changed_by, confirmed_by: last_changed_by)
      throw(:abort) unless self.confirm
    end
  end

  def finalise!(last_changed_by:)
    return false unless can_complete?

    ActiveRecord::Base.transaction do
      system_transaction = member.with_lock do
        Transactions::MemberWithdrawl.create(
          source_id: member,
          source_coin: coin,
          source_quantity: quantity,
          destination: coin,
          destination_coin: coin,
          initiated_by: member,
          authorized_by: last_changed_by
        )
      end

      update!(last_changed_by: last_changed_by)

      if system_transaction.persisted?
        throw(:abort) unless self.complete
      else
        throw(:abort) unless self.crash
      end
    end
  end
end
