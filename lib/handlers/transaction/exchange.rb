# frozen_string_literal: true

module Handlers
  module Transaction
    class Exchange < Handlers::Base

      def call(command)
        with_aggregate(Domain::Transaction, nil, attributes(command)) do |transaction|
          transaction.exchange!
        end
      end

      private

      def attributes(command)
        {
          destination_coin_id: command.destination_coin_id,
          destination_rate: command.destination_rate,
          destination_quantity: command.destination_quantity,
          source_coin_id: command.source_coin_id,
          source_rate: command.source_rate,
          source_quantity: command.source_quantity,
          member_id: command.member_id
        }
      end

    end
  end
end
