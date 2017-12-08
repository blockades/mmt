# frozen_string_literal: true

module Transactions
  class SystemWithdrawl < SystemTransaction
    validates :source_quantity,
              presence: true,
              numericality: { greater_than: 0 }

    validates :destination_quantity,
              :destination_rate,
              :source_rate,
              absence: true

    validates :source_type, inclusion: { in: ["Coin"] }
    validates :destination_type, inclusion: { in: ["Member"] }

    private

    def referring_transaction
      referring_transaction_to_destination
    end

    def publish_to_source
      # Debit source (coin) assets
      coin_events.build(
        coin: source,
        assets: -source_quantity
      )
    end

    def publish_to_destination
      # Debit destination (member) liability
      peer_coin_events.build(
        member: destination,
        coin: destination_coin,
        equity: -source_quantity,
        rate: nil
      )
    end
  end
end
