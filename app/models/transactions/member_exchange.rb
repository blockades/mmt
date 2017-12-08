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
      referring_transaction_to_source
    end

    def publish_to_source
      # Debit source (member) liability of source_coin
      member_coin_events.build(
        coin: source_coin,
        member: source,
        liability: -source_quantity,
        rate: source_rate
      )
      # Credit source_coin equity and assign to source (member)
      peer_coin_events.build(
        coin: source_coin,
        member: source,
        equity: source_quantity,
        rate: source_rate
      )
    end

    def publish_to_destination
      # Credit destination (member) liability of destination_coin
      member_coin_events.build(
        coin: destination_coin,
        member: destination,
        liability: destination_quantity,
        rate: destination_rate
      )
      # Debit destination_coin equity and assign to destination (member)
      peer_coin_events.build(
        coin: destination_coin,
        member: destination,
        equity: -destination_quantity,
        rate: destination_rate
      )
    end
  end
end
