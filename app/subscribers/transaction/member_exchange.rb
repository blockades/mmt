# frozen_string_literal: true

module Subscribers
  module Transaction
    class MemberExchange < Subscribers::Base

      def call(transaction_id)
        transaction = ::Transaction::MemberExchange.find(transaction_id)
      end

    end
  end
end
