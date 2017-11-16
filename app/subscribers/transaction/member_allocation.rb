# frozen_string_literal: true

module Subscribers
  module Transaction
    class MemberAllocation < Subscribers::Base

      def call(transaction_id)
        transaction = ::Transaction::MemberAllocation.find(transaction_id)
      end

    end
  end
end
