# frozen_string_literal: true

module Transaction
  class SystemDeposit < Transaction::Base

    validates :destination_coin_id,
              :destination_rate,
              :destination_quantity,
              :source_member_id,
              presence: true

    validates :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

  end
end
