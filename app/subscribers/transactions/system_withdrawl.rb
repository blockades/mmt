# frozen_string_literal: true

module Subscribers
  module Transactions
    class SystemWithdrawl < Subscribers::Base

      def call(transaction_id)
        transaction = Transaction::SystemWithdrawl.find(transaction_id)
        coin = transaction.source_coin

        # Decrease overall available in system
        # Liability doesnt change
        coin.publish!(
          liability: 0,
          available: -transaction.source_quantity,
          transaction_id: transaction.id
        )
      end

    end
  end
end
