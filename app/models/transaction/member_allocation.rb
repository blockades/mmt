# frozen_string_literal: true

module Transaction
  class MemberAllocation < Transaction::Base

    validates :source_member_id,
              :destination_member_id,
              :destination_coin_id,
              :destination_quantity,
              presence: true

    before_save :publish_to_destination_member,
                :publish_to_source_member

    private

    def publish_to_destination_member
      # Increase available funds to member receiving allocation / gift
      raise ActiveRecord::Rollback unless destination_member.publish!(
        coin: destination_coin,
        liability: destination_quantity,
        transaction_id: self
      )
    end

    def publish_to_source_member
      # Decrease available funds to member performing allocation / gift
      raise ActiveRecord::Rollback unless source_member.publish!(
        coin: destination_coin,
        liability: -destination_quantity,
        transaction_id: self
      )
    end
  end
end
