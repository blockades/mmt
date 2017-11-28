# frozen_string_literal: true

module Transactions
  class SystemWithdrawl < SystemTransaction

    validates :source_quantity,
              presence: true,
              numericality: { greater_than: 0 }

    validates_absence_of :destination_quantity,
                         :destination_rate

    before_create :publish_to_source
                  # :publish_to_destination

    private

    def referring_transaction
      self.class.ordered.for_destination(destination).last
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

    def publish_to_coin
      # Debit source (coin) assets
      throw(:abort) unless coin_events.build(
        coin: source,
        assets: -source_quantity
      ).valid?
    end
  end
end
