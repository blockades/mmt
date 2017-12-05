# frozen_string_literal: true

module Transactions
  class SystemAllocation < SystemTransaction

    validates :destination_rate,
              :destination_quantity,
              presence: true,
              numericality: { greater_than: 0 }

    validates :source_quantity,
              :source_rate,
              absence: true

    validates :source_type, inclusion: { in: ["Coin"] }
    validates :destination_type, inclusion: { in: ["Member"] }

    private

    def referring_transaction
      referring_transaction_to_destination
    end

    def publish_to_source
      # Source (coin) assets stays same
      throw(:abort) unless coin_events.build(
        assets: 0,
        coin: source
      ).valid?
    end

    def publish_to_destination
      # Credit destination (member) liability
      throw(:abort) unless member_coin_events.build(
        rate: destination_rate,
        liability: destination_quantity,
        member: destination,
        coin: destination_coin
      ).valid?
    end
  end
end
