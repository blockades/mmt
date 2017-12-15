# frozen_string_literal: true

class WithdrawlRequest < ApplicationRecord
  belongs_to :member
  belongs_to :last_touched_by, class_name: "Member", foreign_key: :last_touched_by_id
  belongs_to :coin
  belongs_to :system_transaction, optional: true

  [:processed, :confirmed, :completed, :cancelled].each do |reference|
    belongs_to "#{reference}_by".to_sym, class_name: 'Member',
                                         foreign_key: "#{reference}_by_id".to_sym,
                                         inverse_of: "#{reference}_withdrawl_requests",
                                         optional: true
  end

  STATES = %w[pending processing completed cancelled failed].freeze

  validates :quantity, :rate, presence: true, numericality: { greater_than: 0 }

  validates :state, presence: true, inclusion: { in: STATES }

  validate :liability_available

  scope :for_coin, ->(coin) { where coin: coin }
  scope :for_member, ->(member) { where member: member }
  scope :pending, -> { where state: :pending }
  scope :processing, -> { where state: :processing }
  scope :completed, -> { where state: :completed }
  scope :cancelled, -> { where state: :cancelled }
  scope :outstanding, -> { where.not state: [:confirmed, :completed, :cancelled] }

  state_machine :state, initial: :pending do
    event(:process)  { transition pending: :processing }
    event(:cancel)   { transition pending: :cancelled }
    event(:revert)   { transition processing: :pending }
    event(:complete) { transition processing: :completed }
    event(:crash)    { transition any: :failed }
    event(:retry)    { transition failed: :process }

    state :processing do
      validates :processed_by, :last_touched_by, presence: true
      validates_associated :processed_by, :last_touched_by, if: proc { error.empty? }
    end

    state :cancelled do
      validates :cancelled_by, :last_touched_by, presence: true
      validates_associated :cancelled_by, :last_touched_by, if: proc { error.empty? }
    end

    state :completed do
      validates :completed_by, :last_touched_by, :system_transaction, presence: true
      validates_associated :completed_by, :last_touched_by, :system_transaction, if: proc { error.empty? }
    end

    def initialize
      super
    end
  end

  def previous_transaction
    Transactions::MemberWithdrawl.ordered.for_source(member).last
  end

  def transaction_params
    {
      source: member,
      source_coin: coin,
      source_quantity: quantity,
      destination: coin,
      destination_coin: coin
    }
  end

  private

  def liability_available
    liability = member.available_liability(coin) - quantity
    return true if liability.positive? || liability.zero?
    self.errors.add :quantity, "Insufficient funds"
  end
end
