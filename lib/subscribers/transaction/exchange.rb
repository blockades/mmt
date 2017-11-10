# frozen_string_literal: true

module Subscribers
  module Transaction
    class Exchange < Subscribers::Base

      def call(event)
        source_coin = ::Coin.find event.data.fetch(:source_coin_id)
        destination_coin = ::Coin.find event.data.fetch(:destination_coin_id)
        member = Member.find event.data.fetch(:member_id)

        # Increase the source coin holdings
        # Reserves stay the same
        adjustment = source_coin.holdings + event.data.fetch(:source_quantity)
        source_coin.publish!(Events::Coin::State, {
          holdings: adjustment,
          reserves: source_coin.reserves,
          rate: event.data.fetch(:source_rate),
          transaction_id: event.event_id
        })

        # Descrease the destination coin holdings
        # Reserves stay the same
        adjustment = destination_coin.holdings - event.data.fetch(:destination_quantity)
        destination_coin.publish!(Events::Coin::State, {
          holdings: adjustment,
          reserves: destination_coin.reserves,
          rate: event.data.fetch(:destination_rate),
          transaction_id: event.event_id
        })

        # Decrease member holdings of source coin
        adjustment = member.holdings(source_coin.id) - event.data.fetch(:source_quantity)
        member.publish!(Events::Member::Balance, {
          coin_id: source_coin.id,
          holdings: adjustment,
          rate: event.data.fetch(:source_rate),
          transaction_id: event.event_id
        })

        # Increase member holdings of destination coin
        adjustment = member.holdings(destination_coin.id) + event.data.fetch(:destination_quantity)
        member.publish!(Events::Member::Balance, {
          coin_id: destination_coin.id,
          holdings: adjustment,
          rate: event.data.fetch(:destination_rate),
          transaction_id: event.event_id
        })
      end
    end
  end
end
