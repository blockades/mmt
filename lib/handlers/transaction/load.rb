# frozen_string_literal: true

module Handlers
  module Transaction
    class Load < Handlers::Base

      def call(command)
        with_aggregate(Domain::Transaction, nil, command.attributes) do |transaction|
          transaction.load!
        end
      end

    end
  end
end
