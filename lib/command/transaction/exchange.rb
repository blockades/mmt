# frozen_string_literal: true

module Command
  module Transaction
    class Exchange < Command::Base
      attr_accessor :destination_coin_id,
                    :destination_rate,
                    :destination_quantity_for_comparison,
                    :destination_quantity,
                    :source_coin_id,
                    :source_rate,
                    :source_quantity_for_comparison,
                    :source_quantity,
                    :member_id

      validates :source_coin_id,
                :source_rate,
                :source_quantity,
                :destination_coin_id,
                :destination_rate,
                :destination_quantity,
                :member_id,
                presence: true

      validates :source_rate,
                :source_quantity,
                :destination_rate,
                :destination_quantity,
                numericality: { greater_than: 0 }

      validate :current_source_coin_balance

      validate :values_square

      validate :ensure_less_than_central_reserve

      private

      def source_coin
        @source_coin ||= ::Coin.find(source_coin_id)
      end

      def destination_coin
        @destination_coin ||= ::Coin.find(destination_coin_id)
      end

      def member
        @member ||= ::Member.find member_id
      end

      def current_source_coin_balance
        source_coin_balance = member.holdings(source_coin_id)
        return true if source_quantity < source_coin_balance
        self.errors.add :balance, "Insufficient funds to complete this purchase"
      end

      def rates_match
        source_rate_matches = BigDecimal.new(source_rate) == source_coin.btc_rate
        destination_rate_matches = BigDecimal.new(destination_rate) == destination_coin.btc_rate
        return true if source_rate_matches && destination_rate_matches
        self.errors.add :rates_match, "Rate has changed. Please resubmit purchase order after checking the new rate"
      end

      def values_square
        source_value = (source_quantity_for_comparison * source_rate.to_d).to_i
        destination_value = (destination_quantity_for_comparison * destination_rate.to_d).to_i

        # %% QUESTION %%
        # Sometimes this is out by a miniscule fraction
        # Should we be allowing this through at all if its out by a fraction?
        # Should we have some wiggle room to allow transactions that are out
        # by a miniscule margin and allow liquidity in the system to compensate?

        return true if (source_value - destination_value).zero?
        self.errors.add :values_square, "Invalid purchase"
      end

      # We reload coin in case holdings has changed since cached
      def ensure_less_than_central_reserve
        return true if destination_coin && destination_quantity < destination_coin.reload.holdings
        self.errors.add :destination_quantity, "Invalid purchase"
      end
    end
  end
end
