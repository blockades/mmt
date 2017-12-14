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
      # Credit source (member) equity
      equity_events.build(
        member: source,
        coin: destination_coin,
        equity: destination_quantity,
        rate: destination_rate
      )
    end

    def publish_to_destination
      # Credit the destination (coin) assets
      asset_events.build(
        assets: destination_quantity,
        coin: destination,
        member: source,
        rate: destination_rate
      )
    end
  end
end
