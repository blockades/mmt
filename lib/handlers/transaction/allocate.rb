# frozen_string_literal: true

module Handlers
  module Transaction
    class Allocate < Handlers::Base

      def call(command)
        with_aggregate(Domain::Transaction, nil, command.attributes) do |transaction|
          transaction.allocate!
        end
      end

    end
  end
end
