# frozen_string_literal: true

module Subscribers
  module Transaction
    class Load < Subscribers::Base

      # On a load event, we increase both available funds and overall funds
      def call(event)
        ActiveRecord::Base.transaction do
          coin = ::Coin.find event.data.fetch(:destination_coin_id)

          coin.publish!(Events::Coin::State, {
            holdings: coin.holdings + event.data.fetch(:destination_quantity),
            reserves: coin.reserves + event.data.fetch(:destination_quantity),
            rate: event.data.fetch(:destination_rate),
            transaction_id: event.event_id
          })
        end
      end

    end
  end
end
