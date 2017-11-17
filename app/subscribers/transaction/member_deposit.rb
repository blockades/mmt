# frozen_string_literal: true

module Subscribers
  module Transaction
    class MemberDeposit < Subscribers::Base

      def call(transaction_id)
        ActiveRecord::Base.transaction do
          transaction = ::Transaction::MemberDeposit.find(transaction_id)
          coin = transaction.destination_coin
          member = transaction.source_member

          # Increase system liability
          # Available stays the same
          coin.publish!(
            liability: transaction.destination_quantity,
            available: 0,
            transaction_id: transaction.id
          )

          # Increase available coin for member
          member.publish!(
            coin_id: coin.id,
            available: transaction.destination_quantity,
            transaction_id: transaction.id
          )
        end
      end

    end
  end
end
