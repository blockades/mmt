# frozen_string_literal: true

module Transaction
  class SystemExchange < Transaction::Base

    validates :source_rate,
              :source_quantity,
              :destination_rate,
              :destination_quantity,
              :destination_member_id,
              presence: true

    validates :source_rate,
              :source_quantity,
              :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

    validate :destination_member_has_sufficient_source_coin,
             :destination_coin_available,
             :values_match,
             :rates_match

  end
end
