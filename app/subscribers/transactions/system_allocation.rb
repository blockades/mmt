module Subscribers
  module Transactions
    class SystemAllocation < Subscribers::Base

      def call(transaction)
        coin = transaction.destination_coin
        member = transaction.destination_member

        # Increase liability to members
        # Decrease available funds
        event = coin.publish!(
          liability: transaction.destination_quantity,
          available: -transaction.destination_quantity,
          transaction_id: transaction
        )

        # Increase coin available to member
        event = member.publish!(
          coin_id: coin.id,
          liability: transaction.destination_quantity,
          rate: transaction.destination_rate,
          transaction_id: transaction
        )
      end
    end

  end
end
