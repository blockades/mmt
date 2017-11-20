# frozen_string_literal: true

module Subscribers
  module Transactions
    class MemberWithdrawl < Subscribers::Base

      def call(transaction_id)
        ActiveRecord::Base.transaction do
          transaction = Transaction::MemberWithdrawl.find(transaction_id)
          coin = transaction.source_coin
          member = transaction.destination_member

          # Decrease liability
          # Availability stays the same
          coin.publish!(
            liability: -transaction.source_quantity,
            available: 0,
            transaction_id: transaction.id
          )

          # Decrease availability of source coin
          member.publish!(
            coin_id: transaction.source_coin_id,
            liability: -transaction.source_quantity,
            rate: nil,
            transaction_id: transaction.id
          )
        end
      end

    end
  end
end
