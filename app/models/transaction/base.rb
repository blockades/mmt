# frozen_string_literal: true

module Transaction
  class Base < ApplicationRecord
    self.table_name = :transactions

    include Wisper::Publisher

    belongs_to :source_coin, class_name: 'Coin', foreign_key: :source_coin_id
    belongs_to :destination_coin, class_name: 'Coin', foreign_key: :destination_coin_id

    belongs_to :source_member, class_name: 'Member', foreign_key: :source_member_id
    belongs_to :destination_member, class_name: 'Member', foreign_key: :destination_member_id

    has_many :coin_events, foreign_key: :transaction_id, inverse_of: :triggered_by
    has_many :member_coin_events, foreign_key: :transaction_id, inverse_of: :triggered_by

    def readonly?
      Rails.env.development? ? false : !new_record?
    end

    TYPES = %w[
      SystemDeposit SystemAllocation SystemExchange SystemWithdrawl
      MemberDeposit MemberAllocation MemberExchange MemberWithdrawl
    ].freeze

    TYPES.each do |type|
      scope type.underscore.to_sym, -> { where type: "Transaction::#{type}" }

      define_method "#{type.underscore}?" do
        type == self.type.remove('Transaction::')
      end
    end

    validates :type, presence: true, inclusion: { in: TYPES.map{ |type| "Transaction::#{type}" } }

    private

    def rates_match
      source_rate_matches = source_rate.to_d == source_coin.btc_rate
      destination_rate_matches = destination_rate.to_d == destination_coin.btc_rate
      return true if source_rate_matches && destination_rate_matches
      self.errors.add :rates_match, "Rate has changed. Please resubmit purchase order after checking the new rate"
    end

    def values_match
      source_value = ((source_quantity * source_rate).round(Coin::BTC_SUBDIVISION) * 10**(Coin::BTC_SUBDIVISION - source_coin.subdivision)).to_i
      destination_value = ((destination_quantity * destination_rate).round(Coin::BTC_SUBDIVISION) * 10**(Coin::BTC_SUBDIVISION - destination_coin.subdivision)).to_i
      return true if (source_value - destination_value).zero?
      self.errors.add :values_match, "Invalid purchase"
    end
  end
end
