# frozen_string_literal: true

module Subscribers
  module Withdraw
    class Confirmed

      def call(event)
        withdrawl_request = ::WithdrawlRequest.find event.data.fetch(:withdrawl_request_id)

        ActiveRecord::Base.transaction do
          coin = withdrawl_request.coin
          member = withdrawl_request.member

          # We decrease overall funds in the system
          adjustment = coin.reserves - withdrawl_request.quantity
          coin.publish!(Events::Coin::State, {
            holdings: coin.holdings,
            reserves: adjustment,
            transaction_id: withdrawl_request.transaction_id
          })

          # We decrease members holdings
          adjustment = member.holdings(coin.id) - withdrawl_request.quantity
          member.publish!(Events::Member::Balance, {
            coin_id: coin.id,
            holdings: adjustment,
            transaction_id: withdrawl_request.transaction_id
          })

          withdrawl_request.complete!
        end

      end

    end
  end
end

