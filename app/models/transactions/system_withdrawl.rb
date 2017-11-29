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

    before_create :publish_to_source
                  # :publish_to_destination

    private

    def referring_transaction
      self.class.ordered.not_self(self).for_destination(destination).last
    end

    def publish_to_source
      # Debit source (coin) assets
      throw(:abort) unless coin_events.build(
        coin: source,
        assets: -source_quantity
      ).valid?
    end

    # def publish_to_destination
    #   # Credit destination (admin) liability
    #   throw(:abort) unless admin_coin_events.build(
    #     admin: destination,
    #     coin: destination_coin,
    #     liability: source_quantity,
    #     rate: nil
    #   ).valid?
    # end
  end
end
