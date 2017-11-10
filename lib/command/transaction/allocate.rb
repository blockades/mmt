# frozen_string_literal: true

module Command
  module Transaction
    class Allocate < Command::Base
      attr_accessor :destination_coin_id,
                    :destination_rate,
                    :destination_quantity,
                    :member_id,
                    :admin_id

      validates :destination_coin_id,
                :destination_rate,
                :destination_quantity,
                :member_id,
                :admin_id,
                presence: true

      validates :destination_rate,
                :destination_quantity,
                numericality: { greater_than: 0 }

      validate :ensure_less_than_central_reserve

      private

      def destination_coin
        @destination_coin ||= ::Coin.find(destination_coin_id)
      end

      def ensure_less_than_central_reserve
        return true if destination_coin && destination_quantity < destination_coin.holdings
        self.errors.add :destination_quantity, "Invalid purchase"
      end
    end
  end
end
