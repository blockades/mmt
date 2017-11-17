# frozen_string_literal: true

module Transaction
  class SystemExchange < Transaction::Base

    attr_accessor :higher_subdivision,
                  :source_quantity_for_comparison,
                  :destination_quantity_for_comparison

    validates :source_coin_id,
              :source_rate,
              :source_quantity,
              :source_quantity_for_comparison,
              :destination_coin_id,
              :destination_rate,
              :destination_quantity,
              :destination_member_id,
              :destination_quantity_for_comparison,
              :higher_subdivision,
              presence: true

    validates :source_rate,
              :source_quantity,
              :source_quantity_for_comparison,
              :destination_rate,
              :destination_quantity,
              :destination_quantity_for_comparison,
              :higher_subdivision,
              numericality: { greater_than: 0 }

    validate :destination_member_has_sufficient_source_coin,
             :destination_coin_available,
             :values_match,
             :rates_match

  end
end
