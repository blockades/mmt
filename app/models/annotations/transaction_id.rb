# frozen_string_literal: true

module Annotations
  class TransactionId < Annotations::Base

    validates :body, presence: true,
                     format: { with: /\A([a-fA-F0-9]{64})|(0x([A-Fa-f0-9]{64}))\z/ }

    class << self
      def bitcoin_transaction_regex
        /^[a-fA-F0-9]{64}$/
      end

      def ethererum_transaction_regex
        /^0x([A-Fa-f0-9]{64})$/
      end
    end
  end
end
