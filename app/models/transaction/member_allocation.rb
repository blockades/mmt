# frozen_string_literal: true

module Transaction
  class MemberAllocation < Transaction::Base

    attr_accessor :iou

    validates :source_member_id,
              :destination_member_id,
              :destination_coin_id,
              :destination_quantity,
              presence: true

    validates :iou, inclusion: { in: [true, false] }

    validate :source_member_has_sufficient_destination_coin

  end
end
