# frozen_string_literal: true

module Transaction
  class Base < ApplicationRecord
    self.table_name = :transactions

    include Wisper::Publisher

    belongs_to :source_coin, class_name: 'Coin', foreign_key: :source_coin_id
    belongs_to :destination_coin, class_name: 'Coin', foreign_key: :destination_coin_id

    belongs_to :source_member, class_name: 'Member', foreign_key: :source_member_id
    belongs_to :destination_member, class_name: 'Member', foreign_key: :destination_member_id

    has_many :coin_events
    has_many :member_coin_events

    attr_readonly :source_coin_id,
                  :source_member_id,
                  :source_quantity,
                  :source_rate,
                  :destination_coin_id,
                  :destination_member_id,
                  :destination_quantity,
                  :destination_rate

    TYPES = %w[
      SystemDeposit SystemAllocation SystemExchange SystemWithdrawl
      MemberDeposit MemberAllocation MemberExchange MemberWithdrawl
    ].freeze

    TYPES.each do |type|
      scope type.underscore.to_sym, -> { where type: "Transaction::#{type}" }
    end

    validates :type, presence: true, inclusion: { in: TYPES.map{ |type| "Transaction::#{type}" } }

    after_commit :notify_subscribers, on: :create

    private

    def notify_subscribers
      broadcast(:call, id)
    end

    def source_member_has_sufficient_destination_coin
      return true if destination_quantity < source_member.reload.balance(destination_coin_id)
      self.errors.add :destination_quantity, "Insufficient funds to complete this transaction"
    end

    def destination_member_has_sufficient_source_coin
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

    def source_coin_available
      return true if source_coin && source_quantity < source_coin.reload.available
      self.errors.add :source_quantity, "Invalid withdrawl"
    end

    def destination_coin_available
      return true if destination_coin && destination_quantity < destination_coin.reload.available
      self.errors.add :destination_quantity, "Invalid purchase"
    end
  end
end
