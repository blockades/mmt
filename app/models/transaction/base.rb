# frozen_string_literal: true

module Transaction
  class Base < ApplicationRecord
    self.table_name = :transactions
    self.inheritance_column = :type

    include Wisper::Publisher

    belongs_to :source_coin, class_name: 'Coin', foreign_key: :source_coin_id
    belongs_to :destination_coin, class_name: 'Coin', foreign_key: :destination_coin_id

    belongs_to :source_member, class_name: 'Member', foreign_key: :source_member_id
    belongs_to :destination_member, class_name: 'Member', foreign_key: :destination_member_id

    attr_readonly :source_coin_id,
                  :source_member_id,
                  :source_quantity,
                  :source_rate,
                  :destination_coin_id,
                  :destination_member_id,
                  :destination_quantity,
                  :destination_rate

    TYPES = [
      "Transaction::SystemDeposit", "Transaction::SystemAllocation",
      "Transaction::SystemExchange", "Transaction::SystemWithdrawl",
      "Transaction::MemberDeposit", "Transaction::MemberAllocation",
      "Transaction::MemberExchange", "Transaction::MemberWithdrawl"
    ].freeze

    scope :system_deposit, -> { where type: 'Transaction::SystemDeposit' }
    scope :system_allocation, -> { where type: 'Transaction::SystemAllocation' }
    scope :system_exchange, -> { where type: 'Transaction::SystemExchange' }
    scope :system_withdrawl, -> { where type: 'Transaction::SystemWithdrawl' }

    scope :member_deposit, -> { where type: 'Transaction::MemberDeposit' }
    scope :member_allocation, -> { where type: 'Transaction::MemberAllocation' }
    scope :member_exchange, -> { where type: 'Transaction::MemberExchange' }
    scope :member_withdrawl, -> { where type: 'Transaction::MemberWithdrawl' }

    validates :type, presence: true, inclusion: { in: TYPES }

    after_commit :notify_subscribers, on: :create

    private

    def notify_subscribers
      broadcast(:call, id)
    end

    def ensure_less_than_destination_member_balance
      return true if source_quantity < destination_member.reload.balance(source_coin_id)
      errors.add :source_quantity, "Insufficient funds to complete this transaction"
    end

    def source_members_destination_coin_balance
      return true if destination_quantity < source_member.reload.balance(destination_coin_id)
      self.errors.add :destination_quantity, "Insufficient funds to complete this transaction"
    end

    def destination_members_source_coin_balance
      return true if source_quantity < destination_member.reload.balance(source_coin_id)
      self.errors.add :source_quantity, "Insufficient funds to complete this transaction"
    end

    def rates_match
      source_rate_matches = source_rate.to_d == source_coin.btc_rate
      destination_rate_matches = destination_rate.to_d == destination_coin.btc_rate
      return true if source_rate_matches && destination_rate_matches
      self.errors.add :rates_match, "Rate has changed. Please resubmit purchase order after checking the new rate"
    end

    def values_match
      source_value = (source_quantity_for_comparison * source_rate).round(higher_subdivision).to_i
      destination_value = (destination_quantity_for_comparison * destination_rate).round(higher_subdivision).to_i
      return true if (source_value - destination_value).zero?
      self.errors.add :values_match, "Invalid purchase"
    end

    def ensure_availability
      return true if destination_coin && destination_quantity < destination_coin.reload.available
      self.errors.add :destination_quantity, "Invalid purchase"
    end
  end
end
