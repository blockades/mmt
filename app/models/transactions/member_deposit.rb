# frozen_string_literal: true

module Transactions
  class MemberDeposit < SystemTransaction

    validates :destination_quantity,
              presence: true,
              numericality: { greater_than: 0 }

    validates :source_rate,
              :source_quantity,
              absence: true

    validates :source_type, inclusion: { in: ["Coin"] }
    validates :destination_type, inclusion: { in: ["Member"] }

    private

    def referring_transaction
      referring_transaction_to_destination
    end

    def publish_to_source
      # Credit source (coin) assets
      throw(:abort) unless coin_events.build(
        coin: source,
        assets: destination_quantity,
      ).valid?
    end

    def publish_to_destination
      # Credit destination (member) liability
      throw(:abort) unless member_coin_events.build(
        coin: destination_coin,
        member: destination,
        liability: destination_quantity,
        rate: nil
      ).valid?
    end
  end
end
