module Subscribers
  module Transaction
    class Allocate

      # On an allocation event, we increase member's coin holdings
      # and reduce coin's holdings. Reserves stay the same.
      def call(event)
        ActiveRecord::Base.transaction do
          coin = ::Coin.find event.data.fetch(:destination_coin_id)
          member = Member.find event.data.fetch(:member_id)

          adjustment = coin.holdings - event.data.fetch(:destination_quantity)
          coin.publish!(Events::Coin::State, {
            holdings: adjustment,
            reserves: coin.reserves,
            rate: event.data.fetch(:destination_rate),
            transaction_id: event.event_id
          })

          adjustment = member.holdings(coin.id) + event.data.fetch(:destination_quantity)
          member.publish!(Events::Member::Balance, {
            coin_id: coin.id,
            holdings: adjustment,
            rate: event.data.fetch(:destination_rate),
            transaction_id: event.event_id
          })
        end
      end

    end
  end
end
