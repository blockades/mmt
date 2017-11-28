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

    before_create :publish_to_source,
                  :publish_to_destination

    private

    def referring_transaction
      self.class.ordered.for_source(source).last
    end

    def publish_to_source
      # Debit source (member) liability with source_coin
      throw(:abort) unless member_coin_events.build(
        rate: nil,
        liability: -source_quantity,
        member: source,
        coin: source_coin
      ).valid?
    end

    def publish_to_destination
      # Credit destination (coin) assets
      throw(:abort) unless coin_events.build(
        assets: 0,
        coin: destination
      ).valid?
    end
  end
end
