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

    before_save :publish_to_destination,
                :publish_to_source

    private

    def referring_transaction
      self.class.ordered.not_self(self).for_destination(destination).last
    end

    def publish_to_source
      # Debit source (member) liability
      throw(:abort) unless member_coin_events.build(
        coin: source_coin,
        member: source,
        liability: -destination_quantity,
        rate: destination_rate
      ).valid?
    end

    def publish_to_destination
      # Credit destination (member) liability
      throw(:abort) unless member_coin_events.build(
        coin: destination_coin,
        member: destination,
        liability: destination_quantity,
        rate: destination_rate
      ).valid?
    end
  end
end
