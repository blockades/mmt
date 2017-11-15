# frozen_string_literal: true

module Subscribers
  module Transaction
    class Withdraw < Subscribers::Base

      def call(event)
        withdrawl = ::WithdrawlRequest.new(
          member_id: event.data.fetch(:member_id),
          coin_id: event.data.fetch(:source_coin_id),
          quantity: event.data.fetch(:source_quantity),
          transaction_id: event.event_id
        ).tap(&:save)
      end

    end
  end
end
