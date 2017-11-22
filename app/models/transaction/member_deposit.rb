# frozen_string_literal: true

module Transaction
  class MemberDeposit < Transaction::Base

    validates :destination_coin,
              :destination_quantity,
              :source_member,
              presence: true

    validates :destination_quantity,
              numericality: { greater_than: 0 }

    validates_absence_of :source_coin,
                         :source_rate,
                         :source_quantity,
                         :destination_rate,
                         :destination_member

    before_create :publish_to_coin, :publish_to_member

    private

    def publish_to_coin
      # Increase system liability
      # Available stays the same
      raise ActiveRecord::Rollback unless destination_coin.publish!(
        liability: destination_quantity,
        available: 0,
        transaction_id: self
      )
    end

    def publish_to_member
      # Increase available coin for member
      raise ActiveRecord::Rollback unless source_member.publish!(
        coin: destination_coin,
        liability: destination_quantity,
        transaction_id: self
      )
    end
  end
end
