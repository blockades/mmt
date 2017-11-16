# frozen_string_literal: true

module Transaction
  class MemberWithdrawl < Transaction::Base

    validates :source_coin_id,
              :source_quantity,
              :destination_member_id,
              presence: true

    validates :source_quantity,
              numericality: { greater_than: 0 }

    validate :ensure_less_than_destination_member_balance

  end
end

