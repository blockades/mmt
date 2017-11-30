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
      self.class.ordered.not_self(self).for_source(source).last
    end

    def publish_to_source
    #   # Credit source (admin) liability
    #   throw(:abort) unless admin_coin_events.build(
    #     admin: source,
    #     coin: destination_coin,
    #     liability: destination_quantity,
    #     rate: nil,
    #   ).valid?
    end

    def publish_to_destination
      # Credit the destination (coin) assets
      throw(:abort) unless coin_events.build(
        assets: destination_quantity,
        coin: destination
      ).valid?
    end
  end
end
