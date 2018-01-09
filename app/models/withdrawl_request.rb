# frozen_string_literal: true

class WithdrawlRequest < ApplicationRecord
  include AASM

  belongs_to :member
  belongs_to :last_changed_by, class_name: "Member", foreign_key: :last_changed_by_id
  belongs_to :coin
  belongs_to :system_transaction, optional: true

  belongs_to :processing_by, class_name: "Member", foreign_key: :processing_by_id
  belongs_to :cancelled_by, class_name: "Member", foreign_key: :cancelled_by_id
  belongs_to :completed_by, class_name: "Member", foreign_key: :completed_by_id

  has_many :logs, as: :loggable

  STATES = %w[pending processing completed cancelled failed].freeze

  TRACKABLE_STATES = STATES - ["pending"]

  TRACKABLE_STATES.each do |reference|
    belongs_to "#{reference}_by".to_sym, class_name: 'Member',
                                         foreign_key: "#{reference}_by_id".to_sym,
                                         optional: true
  end

  validates :quantity, :rate, presence: true, numericality: { greater_than: 0 }

  validates :state, presence: true, inclusion: { in: STATES }

  validate :liability_available, if: proc { errors.empty? }

  validates :processing_by, :last_changed_by, presence: true, if: :processing?
  validates_associated :processing_by, :last_changed_by, if: :processing?

  validates :cancelled_by, :last_changed_by, presence: true, if: :cancelled?
  validates_associated :cancelled_by, :last_changed_by, if: :cancelled?

  validates :completed_by, :last_changed_by, :system_transaction, presence: true, if: :completed?
  validates_associated :completed_by, :last_changed_by, :system_transaction, if: :completed?

  scope :for_coin, ->(coin) { where coin: coin }
  scope :for_member, ->(member) { where member: member }
  scope :not_self, ->(member) { where.not member: member }
  scope :outstanding, -> { where.not state: [:failed, :completed, :cancelled] }

  aasm column: :state, no_direct_assignment: true do
    state :pending, initial: true
    state :processing
    state :cancelled
    state :completed
    state :failed

    event :process, requires_lock: true do
      transitions from: :pending, to: :processing, after: -> (params) {
        self.last_changed_by = params[:member]
        self.processing_by = params[:member]
      }

      after { log_state_change(member_id: processing_by.id) }
    end

    event :cancel, requires_lock: true do
      transitions from: :pending, to: :cancelled, after: -> (params) {
        self.last_changed_by = params[:member]
        self.cancelled_by = params[:member]
      }

      after { log_state_change(member_id: cancelled_by.id) }
    end

    event :complete, requires_lock: true do
      transitions from: :processing, to: :completed, after: -> (params) {
        self.last_changed_by = params[:member]
        self.completed_by = params[:member]
      }

      after do
        ActiveRecord::Base.transaction do
          member.with_lock do
            Transactions::MemberWithdrawl.create(
              source: member,
              source_coin: coin,
              source_quantity: quantity,
              destination: coin,
              destination_coin: coin,
              previous_transaction: previous_transaction,
              initiated_by: member,
              authorized_by: completed_by
            )
          end
        end
        log_state_change(member_id: completed_by.id)
      end
    end

    event :fail do
      transitions from: [:pending, :processing], to: :failed, after: -> (params) {
        self.last_changed_by = params[:member]
        self.failed_by = params[:member]
      }

      after { log_state_change(member_id: failed_by.id) }
    end
  end

  def log_state_change(member_id:)
    logs.create(data: {
      member_id: member_id,
      withdrawl_request_id: id,
      state: state
    })
  end

  def previous_transaction
    Transactions::MemberWithdrawl.ordered.for_source(member).last
  end

  private

  def liability_available
    liability = member.available_liability(coin) - quantity
    return true if liability.positive? || liability.zero?
    self.errors.add :quantity, "Insufficient funds"
  end
end
