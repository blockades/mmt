# frozen_string_literal: true

module Command
  module Transaction
    class Exchange
      attr_accessor :destination_coin_id,
                    :destination_rate,
                    :destination_quantity,
                    :source_coin_id,
                    :source_rate,
                    :source_quantity,
                    :member_id

      validates :source_coin_id,
                :source_rate,
                :source_quantity,
                :destination_coin_id,
                :destination_rate,
                :destination_quantity,
                :member_id,
                presence: true

      validates :source_rate,
                :source_quantity,
                :destination_rate,
                :destination_quantity,
                numericality: { greater_than: 0 }

    end
  end
end
