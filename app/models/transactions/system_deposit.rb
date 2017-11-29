# frozen_string_literal: true

module Transactions
  class SystemDeposit < Transaction

    validates :destination_rate,
              :destination_quantity,
              presence: true,
              numericality: { greater_than: 0 }

    validates :source_rate,
              :source_quantity,
              absence: true

    before_create :publish_to_destination
                  # :publish_to_source

    private

    def referring_transaction
      self.class.ordered.for_source(source).last
    end

    # def publish_to_source
    #   # Debit source (admin) liability
    #   throw(:abort) unless admin_coin_events.build(
    #     admin: source,
    #     coin: destination_coin,
    #     liability: -destination_quantity,
    #     rate: nil,
    #   ).valid?
    # end

    def publish_to_destination
      # Credit the destination (coin) assets
      throw(:abort) unless coin_events.build(
        assets: destination_quantity,
        coin: destination
      ).valid?
    end
  end
end