# frozen_string_literal: true

module Transactions
  class MemberExchange < SystemTransaction

    validates :source_rate,
              :source_quantity,
              :destination_rate,
              :destination_quantity,
              presence: true,
              numericality: { greater_than: 0 }

    validates :source_type, inclusion: { in: ["Member"] }
    validates :destination_type, inclusion: { in: ["Member"] }

    validate :values_match, :rates_match, :not_fiat_to_fiat, if: proc { errors.empty? }

    private

    def referring_transaction
      self.class.ordered.not_self(self).for_source(source).last
    end

    def publish_to_source
      # Debit source (member) liability of source_coin
      throw(:abort) unless member_coin_events.build(
        coin: source_coin,
        member: source,
        liability: -source_quantity,
        rate: source_rate
      ).valid?
    end

    def publish_to_destination
      # Credit destination (member) liability of destination_coin
      throw(:abort) unless member_coin_events.build(
        coin: destination_coin,
        member: destination,
        liability: destination_quantity,
        rate: destination_rate
      ).valid?
    end
  end
end
