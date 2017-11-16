module Subscribers
  module Transaction
    class SystemAllocation < Subscribers::Base

      def call(transaction_id)
        ActiveRecord::Base.transaction do
          transaction = ::Transaction::SystemAllocation.find(transaction_id)

          coin = transaction.destination_coin
          member = transaction.destination_member

          coin.publish!(
            liability: transaction.destination_quantity,
            available: -transaction.destination_quantity,
            transaction_id: transaction.id
          )

          member.publish!(
            coin_id: coin.id,
            available: transaction.destination_quantity,
            rate: transaction.destination_rate,
            transaction_id: transaction.id
          )
        end
      end

    end
  end
end
