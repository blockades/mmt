# frozen_string_literal: true

module Handlers
  module Transaction
    class Withdraw < Handlers::Base

      def call(command)
        with_aggregate(Domain::Transaction, nil, command.attributes) do |transaction|
          transaction.withdraw!
        end
      end

    end
  end
end
