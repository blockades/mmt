# frozen_string_literal: true

module Transactions
  class MemberWithdrawl < SystemTransaction
    validates :source_quantity,
              presence: true,
              numericality: { greater_than: 0 }

    validates :destination_quantity,
              :destination_rate,
              :source_rate,
              absence: true

    validates :source_type, inclusion: { in: ["Member"] }
    validates :destination_type, inclusion: { in: ["Coin"] }

    private

    def referring_transaction
      referring_transaction_to_source
    end

    def publish_to_source
      # Debit source (member) liability with source_coin
      member_coin_events.build(
        rate: nil,
        liability: -source_quantity,
        member: source,
        coin: source_coin
      )
    end

    def publish_to_destination
      # Debit destination (coin) assets
      coin_events.build(
        assets: -source_quantity,
        coin: destination
      )
    end
  end
end
