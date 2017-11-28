# frozen_string_literal: true

module Transactions
  class MemberAllocation < SystemTransaction

    validates :destination_quantity,
              presence: true

    before_save :publish_to_destination,
                :publish_to_source

    private

    def referring_transaction
      self.class.ordered.for_destination(destination).last
    end

    def publish_to_source
      # Debit source (member) liability
      throw(:abort) unless member_coin_events.build(
        coin: source_coin,
        member: source,
        liability: -destination_quantity,
        rate: nil
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
