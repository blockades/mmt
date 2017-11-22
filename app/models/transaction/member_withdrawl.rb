# frozen_string_literal: true

module Transaction
  class MemberWithdrawl < Transaction::Base

    validates :source_coin,
              :source_quantity,
              :destination_member,
              presence: true

    validates :source_quantity,
              numericality: { greater_than: 0 }

    validates_absence_of :source_member,
                         :source_rate,
                         :destination_coin,
                         :destination_quantity,
                         :destination_rate

    before_create :publish_to_coin, :publish_to_member

    private

    def publish_to_coin
      # Decrease liability
      # Availability stays the same
      raise ActiveRecord::Rollback unless source_coin.publish!(
        liability: -source_quantity,
        available: 0,
        transaction_id: self
      )
    end

    def publish_to_member
      # Decrease availability of source coin
      raise ActiveRecord::Rollback unless destination_member.publish!(
        coin: source_coin,
        liability: -source_quantity,
        rate: nil,
        transaction_id: self
      )
    end
  end
end
