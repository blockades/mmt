# frozen_string_literal: true

module Subscribers
  module Transactions
    class SystemExchange < Subscribers::Base

      def call(transaction_id)
        ActiveRecord::Base.transaction do
          transaction = Transaction::SystemExchange.find(transaction_id)
          source_coin = transaction.source_coin
          destination_coin = transaction.destination_coin
          member = transaction.destination_member

          # Decrease source coin liability
          # Increase source coin availability
          source_coin.publish!(
            liability: -transaction.source_quantity,
            available: transaction.source_quantity,
            transaction_id: transaction.id
          )

          # Increase destination coin liability
          # Decrease destination coin availability
          destination_coin.publish!(
            liability: transaction.destination_quantity,
            available: -transaction.destination_quantity,
            transaction_id: transaction.id
          )

          # Decrease availability of source coin
          member.publish!(
            coin_id: source_coin.id,
            liability: -transaction.source_quantity,
            rate: transaction.source_rate,
            transaction_id: transaction.id
          )

          # Increase availability of destination coin
          member.publish!(
            coin_id: destination_coin.id,
            liability: transaction.destination_quantity,
            rate: transaction.destination_rate,
            transaction_id: transaction.id
          )
        end
      end
    end
  end
end
