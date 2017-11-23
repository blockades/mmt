# frozen_string_literal: true

module Transaction
  class SystemAllocation < Transaction::Base

    validates :destination_coin,
              :destination_rate,
              :destination_quantity,
              :destination_member,
              :source_member,
              presence: true

    validates :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

    validates_absence_of :source_coin,
                         :source_quantity,
                         :source_rate

    before_create :publish_to_coin, :publish_to_member

    private

    def publish_to_coin
      # Increase liability to members
      # Decrease available funds
     raise ActiveRecord::Rollback unless destination_coin.publish!(
        liability: destination_quantity,
        available: -destination_quantity,
        transaction_id: self
      )
    end

    def publish_to_member
      # Increase coin available to member
     raise ActiveRecord::Rollback unless destination_member.publish!(
        coin: destination_coin,
        liability: destination_quantity,
        rate: destination_rate,
        transaction_id: self
      )
    end
  end
end
