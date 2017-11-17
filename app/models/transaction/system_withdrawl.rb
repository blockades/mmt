# frozen_string_literal: true

module Transaction
  class SystemWithdrawl < Transaction::Base

    validates :source_coin_id,
              :source_quantity,
              :source_member_id,
              presence: true

    validates :source_quantity, numericality: { greater_than: 0 }

    validate :source_coin_available

  end
end
