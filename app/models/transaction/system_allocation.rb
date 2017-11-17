# frozen_string_literal: true

module Transaction
  class SystemAllocation < Transaction::Base

    validates :destination_coin_id,
              :destination_rate,
              :destination_quantity,
              :destination_member_id,
              :source_member_id,
              presence: true

    validates :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

    validate :destination_coin_available

  end
end
