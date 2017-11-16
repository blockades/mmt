# frozen_string_literal: true

module Transaction
  class MemberAllocation < Transaction::Base
    validates :source_member_id,
              :destination_member_id,
              :destination_quantity,
  end
end
