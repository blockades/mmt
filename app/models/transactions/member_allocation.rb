# frozen_string_literal: true

module Transactions
  class MemberAllocation < SystemTransaction

    validates :destination_rate,
              :destination_quantity,
              presence: true

    validates :source_quantity,
              :source_rate,
              absence: true

    validates :source_type, inclusion: { in: ["Member"] }
    validates :destination_type, inclusion: { in: ["Member"] }

    private

    def referring_transaction
      self.class.ordered.not_self(self).for_destination(destination).last
    end

    def publish_to_source
      # Debit source (member) liability
      member_coin_events.build(
        coin: source_coin,
        member: source,
        liability: -destination_quantity,
        rate: destination_rate
      )
    end

    def publish_to_destination
      # Credit destination (member) liability
      member_coin_events.build(
        coin: destination_coin,
        member: destination,
        liability: destination_quantity,
        rate: destination_rate
      )
    end
  end
end
