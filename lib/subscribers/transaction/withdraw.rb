# frozen_string_literal: true

module Subscribers
  module Transaction
    class Withdraw < Subscribers::Base

      def call(event)
        coin = ::Coin.find event.data.fetch(:source_coin_id)
        member = ::Member.find event.data.fetch(:member_id)

        # We decrease overall funds in the system
        adjustment = coin.reserves - event.data.fetch(:source_quantity)
        coin.publish!(Events::Coin::State, {
          holdings: coin.holdings,
          reserves: adjustment,
          transaction_id: event.event_id
        })

        # We decrease members holdings
        adjustment = member.holdings(coin.id) - event.data.fetch(:source_quantity)
        member.publish!(Events::Member::Balance, {
          coin_id: coin.id,
          holdings: adjustment,
          transaction_id: event.event_id
        })
      end

    end
  end
end
