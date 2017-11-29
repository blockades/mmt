# frozen_string_literal: true

module Transactions
  class MemberDeposit < Transaction

    validates :destination_quantity,
              presence: true

    validates :destination_quantity,
              numericality: { greater_than: 0 }

    validates_absence_of :source_rate,
                         :source_quantity,
                         :destination_rate,

    before_create :publish_to_source,
                  :publish_to_destination

    private

    def referring_transaction
      self.class.ordered.for_destination(destination).last
    end

    def publish_to_source
      # Debit source (coin) assets
      throw(:abort) unless coin_events.build(
        coin: source,
        assets: 0,
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
