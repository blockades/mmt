class WithdrawlRequest < ApplicationRecord

  belongs_to :member
  belongs_to :coin

  belongs_to :last_changed_by, class_name: 'Member', foreign_key: :last_changed_by_id
  belongs_to :progressed_by, class_name: 'Member', foreign_key: :in_progress_by_id
  belongs_to :confirmed_by, class_name: 'Member', foreign_key: :confirmed_by_id
  belongs_to :cancelled_by, class_name: 'Member', foreign_key: :cancelled_by_id
  belongs_to :completed_by, class_name: 'Member', foreign_key: :cancelled_by_id

  validates :quantity, presence: true,
                       numericality: { greater_than: 0 }

  scope :pending, -> { where state: :pending }
  scope :in_progress, -> { where state: :in_progress }
  scope :confirmed, -> { where state: :confirmed }
  scope :completed, -> { where state: :completed }
  scope :cancelled, -> { where state: :cancelled }
  scope :outstanding, -> { where.not state: [:completed, :cancelled] }

  STATES = [:pending, :in_progress, :confirmed, :completed, :cancelled].freeze

  state_machine :state, initial: :pending do
    event(:progress) { transition pending: :in_progress }
    event(:cancel)      { transition pending: :cancelled }
    event(:confirm)     { transition [:pending, :in_progress] => :confirmed } # same as complete?
    event(:complete)    { transition confirmed: :completed }

    after_transition on: :confirm, do: :withdraw!

    def initialize
      super
    end
  end

  def progress!(in_progress_by_id)
    raise ArgumentError.new("Must be a UUID") unless in_progress_by_id =~ uuid_regex
    ActiveRecord::Base.transaction do
      update! last_changed_by_id: in_progress_by_id,
              in_progress_by_id: in_progress_by_id
      self.progress
    end
  end

  def confirm!(confirmed_by_id)
    raise ArgumentError.new("Must be a UUID") unless confirmed_by_id =~ uuid_regex
    ActiveRecord::Base.transaction do
      update! last_changed_by_id: confirmed_by_id,
              confirmed_by_id: confirmed_by_id
      self.confirm
    end
  end

  def complete!(completed_by_id)
    raise ArgumentError.new("Must be a UUID") unless completed_by_id =~ uuid_regex
    ActiveRecord::Base.transaction do
      update! last_changed_by_id: completed_by_id,
              completed_by_id: completed_by_id
      self.complete
    end
  end

  def cancel!(cancelled_by_id)
    raise ArgumentError.new("Must be a UUID") unless cancelled_by_id =~ uuid_regex
    ActiveRecord::Base.transaction do
      update! last_changed_by_id: cancelled_by_id,
              cancelled_by_id: cancelled_by_id
      self.cancel
    end
  end

  private

  def withdraw!
    ActiveRecord::Base.transaction do
      # We decrease overall funds in the system
      adjustment = coin.reserves - quantity
      coin.publish!(Events::Coin::State, {
        holdings: coin.holdings,
        reserves: adjustment,
        transaction_id: transaction_id
      })
      # We decrease members holdings
      adjustment = member.holdings(coin.id) - quantity
      member.publish!(Events::Member::Balance, {
        coin_id: coin.id,
        holdings: adjustment,
        transaction_id: transaction_id
      })
      complete!(confirmed_by_id)
    end
  end
end
