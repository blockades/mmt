# frozen_string_literal: true

module Transactions
  class SystemDeposit < SystemTransaction

    validates :destination_rate,
              :destination_quantity,
              presence: true,
              numericality: { greater_than: 0 }

    validates :source_rate,
              :source_quantity,
              absence: true

    validates :source_type, inclusion: { in: ["Member"] }
    validates :destination_type, inclusion: { in: ["Coin"] }

    private

    def referring_transaction
      referring_transaction_to_source
    end

    def publish_to_source
    #   # Credit source (admin) liability
    #   admin_coin_events.build(
    #     admin: source,
    #     coin: destination_coin,
    #     liability: destination_quantity,
    #     rate: nil,
    #   )
    end

    def publish_to_destination
      # Credit the destination (coin) assets
      coin_events.build(
        assets: destination_quantity,
        coin: destination
      )
    end
  end
end
