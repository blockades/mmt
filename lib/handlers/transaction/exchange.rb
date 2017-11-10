# frozen_string_literal: true

module Handlers
  module Transaction
    class Exchange < Handlers::Base

      def call(command)
        with_aggregate(Domain::Transaction, nil, command.attributes) do |transaction|
          transaction.exchange!
        end
      end

    end
  end
end
