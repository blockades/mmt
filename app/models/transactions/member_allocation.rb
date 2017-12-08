# frozen_string_literal: true

module Transactions
  class MemberAllocation < SystemTransaction
    validates :destination_quantity,
              :source_rate,
              presence: true

    validates :destination_rate,
              :source_quantity,
              absence: true

    validates :source_type, inclusion: { in: ["Member"] }
    validates :destination_type, inclusion: { in: ["Member"] }

    private

    def referring_transaction
      referring_transaction_to_destination
    end

    def publish_to_source
      # Debit source (member) liability
      liability_events.build(
        coin: source_coin,
        member: source,
        liability: -destination_quantity,
        rate: source_rate
      ).valid?
    end

    def publish_to_destination
      # Credit destination (member) liability
      liability_events.build(
        coin: destination_coin,
        member: destination,
        liability: destination_quantity,
        rate: destination_rate
      )
    end
  end
end
