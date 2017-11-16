# frozen_string_literal: true

module Subscribers
  module Transaction
    class SystemWithdrawl < Subscribers::Base

      def call(transaction_id)
        transaction = ::Transaction::SystemWithdrawl.find(transaction_id)

      end

    end
  end
end
