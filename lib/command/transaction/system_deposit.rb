# frozen_string_literal: true

module Command
  module Transaction
    class SystemDeposit < Command::Base
      attr_accessor :destination_coin_id,
                    :destination_rate,
                    :destination_quantity,
                    :admin_id

      validates :destination_coin_id,
                :destination_rate,
                :destination_quantity,
                :admin_id,
                presence: true

      validates :destination_rate,
                :destination_quantity,
                numericality: { greater_than: 0 }
    end
  end
end
