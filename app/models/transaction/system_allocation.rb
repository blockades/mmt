# frozen_string_literal: true

module Transaction
  class SystemAllocation < Transaction::Base

    validates :destination_coin,
              :destination_rate,
              :destination_quantity,
              :destination_member,
              :source_member,
              presence: true

    validates :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

    validates_absence_of :source_coin,
                         :source_quantity,
                         :source_rate

    validate :destination_coin_available

  end
end
