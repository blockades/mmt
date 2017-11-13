# frozen_string_literal: true

module Handlers
  module Transaction
    class SystemDeposit < Handlers::Base

      def call(command)
        with_aggregate(Domain::Transaction, nil, command.attributes) do |transaction|
          transaction.system_deposit!
        end
      end

    end
  end
end
