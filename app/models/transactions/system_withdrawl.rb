# frozen_string_literal: true

module Transactions
  class SystemWithdrawl < Transactions::Base
    validates :source_quantity,
              presence: true,
              numericality: { greater_than: 0 }

    validates :destination_quantity,
              :destination_rate,
              absence: true

    validates :source_type, inclusion: { in: ["Coin"] }
    validates :destination_type, inclusion: { in: ["Member"] }

    private

    def referring_transaction
      referring_transaction_to_destination
    end

    def publish_to_source
      # Debit source (coin) assets
      asset_events.build(
        coin: source,
        assets: -source_quantity,
        member: destination,
        rate: destination_coin.btc_rate
      )
    end

    def publish_to_destination
      # Debit destination (member) liability
      equity_events.build(
        member: destination,
        coin: destination_coin,
        equity: -source_quantity,
        rate: destination_coin.btc_rate
      )
    end
  end
end
