# frozen_string_literal: true

module Subscribers
  module Transaction
    class MemberDeposit < Subscribers::Base

      def call(transaction_id)
        transaction = ::Transaction::MemberDeposit.find(transaction_id)
      end

    end
  end
end
