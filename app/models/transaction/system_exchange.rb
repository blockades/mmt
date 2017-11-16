# frozen_string_literal: true

module Transaction
  class SystemExchange < Transaction::Base

    validates :source_coin_id,
              :source_rate,
              :source_quantity,
              :destination_coin_id,
              :destination_rate,
              :destination_quantity,
              :destination_member_id,
              presence: true

    validates :source_rate,
              :source_quantity,
              :destination_rate,
              :destination_quantity,
              numericality: { greater_than: 0 }

    validate :source_members_source_coin_balance,
             :ensure_less_than_central_reserve,
             :values_match,
             :rates_match

  end
end
