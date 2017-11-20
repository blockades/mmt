# frozen_string_literal: true

module Subscribers
  module Transactions
    class SystemDeposit < Subscribers::Base

      def call(transaction_id)
        transaction = Transaction::SystemDeposit.find(transaction_id)
        coin = transaction.destination_coin

        # Increase overall available in system
        # Liability doesnt change
        coin.publish!(
          liability: 0,
          available: transaction.destination_quantity,
          transaction_id: transaction.id
        )
      end

    end
  end
end
