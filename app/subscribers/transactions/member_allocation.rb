# frozen_string_literal: true

module Subscribers
  module Transactions
    class MemberAllocation < Subscribers::Base

      def call(transaction_id)
        ActiveRecord::Base.transactiond do
          transaction = Transaction::MemberAllocation.find(transaction_id)
          source_member = transaction.source_member
          destination_member = transaction.destination_member
          coin = transaction.destination_coin

          # Decrease available funds to member performing allocation / gift
          source_member.publish!(
            coin_id: coin.id,
            liability: -transaction.destination_quantity,
            transaction_id: transaction.id
          )

          # Increase available funds to member receiving allocation / gift
          destination_member.publish!(
            coin_id: coin.id,
            liability: transaction.destination_quantity,
            transaction_id: transaction.id
          )

          # %%QUESTION%%

          # Should we introduce the concept of IOU or Gift as a separate entity?
          # Or is this just a new IOU boolean field on the Transaction table?
          # e.g.
          # Gift.create!(
          #   transaction_id: transaction.id,
          #   iou: true,
          #   quantity: 10,
          #   coin_id: coin.id,
          #   destination_member_id: destination_member.id,
          #   source_member_id: source_member.id
          # )
          # OR
          # Transaction::MemberAllocation.create!(
          #   iou: true,
          #   quantity: 10,
          #   coin_id: coin.id,
          #   destination_member_id: destination_member.id,
          #   source_member_id: source_member.id
          # )

          # %%THOUGHT%%
          # a new field on the transaction table,
          # validate boolean on member allocation and validate its
          # always nil on all other transaction types
          # No need to record the same information twice.

          # %%ANOTHER THOUGHT%%
          # What happens when someone wants to change the value of IOU from
          # true to false. We never want to perform an update action on a transaction.
          # Therefore we should create a Gift entity associated with the transaction
          # Gift belongs_to transaction and we can delegate fields to the relevant transaction
        end
      end

    end
  end
end
