# frozen_string_literal: true

class WithdrawlRequest < ApplicationRecord
  belongs_to :member
  belongs_to :coin
  belongs_to :system_transaction, optional: true

  [:last_touched_by, :processed_by, :confirmed_by, :completed_by, :cancelled_by].each do |reference|
    belongs_to reference, class_name: 'Member', foreign_key: "#{reference}_id".to_sym
  end

  STATES = %w[pending processing completed cancelled failed].freeze

  validates :quantity, :rate, presence: true, numericality: { greater_than: 0 }

  validates :state, presence: true, inclusion: { in: STATES }

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
      validates_presence_of :processed_by, :last_touched_by
    end

    state :cancelled do
      validates_presence_of :cancelled_by, :last_touched_by
    end

    state :completed do
      validates_presence_of :completed_by, :last_touched_by, :system_transaction
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
end
