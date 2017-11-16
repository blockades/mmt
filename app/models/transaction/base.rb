# frozen_string_literal: true

module Transaction
  class Base < ApplicationRecord
    self.table_name = 'transactions'

    include Wisper::Publisher

    belongs_to :source_coin
    belongs_to :destination_coin

    belongs_to :source_member
    belongs_to :destination_member

    attr_readonly :source_coin_id,
                  :source_member_id,
                  :source_quantity,
                  :source_rate,
                  :destination_coin_id,
                  :destination_member_id,
                  :destination_quantity,
                  :destination_rate

    TYPES = [
      "SystemDeposit", "SystemAllocation",
      "SystemExchange", "SystemWithdrawl",
      "MemberDeposit", "MemberAllocation",
      "MemberExchange", "MemberWithdrawl"
    ].freeze

    scope :system_deposit, -> { where type: 'SystemDeposit' }
    scope :system_allocation, -> { where type: 'SystemAllocation' }
    scope :system_exchange, -> { where type: 'SystemExchange' }
    scope :system_withdrawl, -> { where type: 'SystemWithdrawl' }

    scope :member_deposit, -> { where type: 'MemberDeposit' }
    scope :member_allocation, -> { where type: 'MemberAllocation' }
    scope :member_exchange, -> { where type: 'MemberExchange' }
    scope :member_withdrawl, -> { where type: 'MemberWithdrawl' }

    validates :type, presence: true, inclusion: { in: TYPES }

    after_commit :notify_subscribers, on: :create

    private

    def notify_subscribers
      publish(:call, self)
    end

    def ensure_less_than_destination_member_balance
      return if destination_member && source_quantity < destination_member.holdings(coin_id)
      errors.add :source_quantity, "Insufficient funds"
    end

    def source_members_source_coin_balance
      source_coin_balance = source_member.holdings(source_coin_id)
      return true if source_quantity < source_coin_balance
      self.errors.add :source_coin_quantity, "Insufficient funds to complete this purchase"
    end

    def destination_members_destination_coin_balance
      destination_coin_balance = destination_member.holdings(destination_coin_id)
      return true if destination_quantity < destination_coin_balance
      self.errors.add :destination_coin_quantity, "Insufficient funds to complete this purchase"
    end

    def rates_match
      source_rate_matches = source_rate.to_d == source_coin.btc_rate
      destination_rate_matches = destination_rate.to_d == destination_coin.btc_rate
      return true if source_rate_matches && destination_rate_matches
      self.errors.add :rates_match, "Rate has changed. Please resubmit purchase order after checking the new rate"
    end

    def values_match
      source_value = (source_quantity_for_comparison * source_rate.to_d).to_i
      destination_value = (destination_quantity_for_comparison * destination_rate.to_d).to_i
      self.errors.add :values_square, "Invalid purchase"
    end

    def ensure_less_than_central_reserve
      return true if destination_coin && destination_quantity < destination_coin.reload.holdings
      self.errors.add :destination_quantity, "Invalid purchase"
    end
  end
end
