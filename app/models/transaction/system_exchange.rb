# frozen_string_literal: true

module Transaction
  class SystemExchange < Transaction::Base

    validates :source_rate,
              :source_quantity,
              :source_coin,
              :destination_rate,
              :destination_quantity,
              :destination_member,
              :destination_coin,
              presence: true

    validates :source_rate,
              :source_quantity,
              :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

    validates_absence_of :source_member

    validate :values_match, :rates_match

  end
end
