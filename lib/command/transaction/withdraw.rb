# frozen_string_literal: true

module Command
  module Transaction
    class Withdraw
      attr_accessor :source_coin_id,
                    :source_rate,
                    :source_quantity,
                    :member_id

      validates :source_coin_id,
                :source_rate,
                :source_quantity,
                :member_id,
                presence: true

      validates :source_rate,
                :source_quantity,
                numericality: { greater_than: 0 }

      def ensure_less_than_balance
        coin = ::Coin.find coin_id
        member = ::Member.find member_id
        current_holdings = member.coin_holdings(coin_id)
        quantity_as_integer = quantity.to_d * (10**coin.subdivision)
        return if coin && quantity_as_integer < current_holdings
        errors.add :quantity, "Balance too low to deallocate #{quantity}"
      end
    end
  end
end
