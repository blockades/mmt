# frozen_string_literal: true

module Handlers
  module Transaction
    class Deposit < Handlers::Base

      def call(command)
        with_aggregate(Domain::Transaction, nil, command.attributes) do |transaction|
          transaction.deposit!
        end
      end

    end
  end
end
