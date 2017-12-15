# frozen_string_literal: true

class WithdrawlRequest < ApplicationRecord
  belongs_to :member
  belongs_to :coin
  belongs_to :system_transaction, optional: true

  [:last_touched_by, :processing_by, :confirmed_by, :completed_by, :cancelled_by].each do |reference|
    belongs_to reference, class_name: 'Member', foreign_key: "#{reference}_id".to_sym
  end

  STATES = %w(pending processing confirmed completed cancelled failed).freeze

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  validates :state, presence: true, inclusion: { in: STATES }

  scope :for_coin, ->(coin) { where coin: coin }
  scope :for_member, ->(member) { where member: member }
  scope :pending, -> { where state: :pending }
  scope :processing, -> { where state: :processing }
  scope :confirmed, -> { where state: :confirmed }
  scope :completed, -> { where state: :completed }
  scope :cancelled, -> { where state: :cancelled }
  scope :outstanding, -> { where.not state: [:confirmed, :completed, :cancelled] }

  state_machine :state, initial: :pending do
    event(:process) { transition pending: :processing }
    event(:cancel)   { transition pending: :cancelled }
    event(:confirm)  { transition :processing => :confirmed }
    event(:complete) { transition confirmed: :completed }
    event(:crash)    { transition any: :failed }
    event(:retry)    { transition failed: :confirm }

    after_transition on: :confirm, do: :finalise!

    def initialize
      super
    end
  end

  def previous_transaction
    Transactions::MemberWithdrawl.ordered.for_source(member).last
  end

  def confirm!(last_changed_by:)
    return false unless can_confirm?

    ActiveRecord::Base.transaction do
      update!(last_changed_by: last_changed_by, confirmed_by: last_changed_by)
      throw(:abort) unless self.confirm
    end
  end

  def finalise!
    return false unless can_complete?

    ActiveRecord::Base.transaction do
      system_transaction = member.with_lock do
        Transactions::MemberWithdrawl.create(
          source: member,
          source_coin: coin,
          source_quantity: quantity,
          destination: coin,
          destination_coin: coin,
          initiated_by: member,
          authorized_by: last_touched_by
        )
      end

      update!(last_touched_by: last_touched_by)

      if system_transaction.persisted?
        throw(:abort) unless self.complete
      else
        throw(:abort) unless self.crash
      end
    end
  end
end
