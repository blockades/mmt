# frozen_string_literal: true

module Command
  module Transaction
    class Load
      attr_accessor :destination_coin_id,
                    :destination_rate,
                    :destination_quantity,
                    :member_id

      validates :destination_coin_id,
                :destination_rate,
                :destination_quantity,
                :member_id,
                presence: true

      validates :destination_rate,
                :destination_quantity,
                numericality: { greater_than: 0 }

    end
  end
end
