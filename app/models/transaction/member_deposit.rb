# frozen_string_literal: true

module Transaction
  class MemberDeposit < Transaction::Base

    validates :destination_coin_id,
              :destination_quantity,
              :source_member_id,
              presence: true

    validates :destination_quantity,
              numericality: { greater_than: 0 }

  end
end
