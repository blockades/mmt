# frozen_string_literal: true

module Subscribers
  module Transaction
    class MemberExchange < Subscribers::Base

      def call(transaction_id)
        ActiveRecord::Base.transaction do
          transaction = ::Transaction::MemberExchange.find(transaction_id)
          # This functionality does not yet exist!
        end
      end

    end
  end
end
