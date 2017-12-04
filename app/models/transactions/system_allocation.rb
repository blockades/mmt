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
      self.class.ordered.not_self(self).for_destination(destination).last
    end

    def publish_to_source
      # Source (coin) assets stays same
      coin_events.build(
        assets: 0,
        coin: source
      )
    end

    def publish_to_destination
      # Credit destination (member) liability
      member_coin_events.build(
        rate: destination_rate,
        liability: destination_quantity,
        member: destination,
        coin: destination_coin
      )
    end
  end
end
