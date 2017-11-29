# frozen_string_literal: true

module Transaction
  class MemberAllocation < Transaction::Base

    validates :source_member_id,
              :destination_member_id,
              :destination_coin_id,
              :destination_quantity,
              presence: true

    validate :source_member_has_sufficient_destination_coin

  end
end
