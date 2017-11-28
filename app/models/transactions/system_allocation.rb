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

    before_create :publish_to_source, :publish_to_destination

    private

    def referring_transaction
      self.class.ordered.not_self(self).for_destination(destination).last
    end

    def publish_to_source
      # Debit source (coin) assets
      throw(:abort) unless coin_events.build(
        assets: -destination_quantity,
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
