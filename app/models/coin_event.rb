# frozen_string_literal: true

class CoinEvent < ApplicationRecord

  belongs_to :coin

  attr_readonly :liability, :available,
                :coin_id,
                :transaction_id

  validates :liability,
            :available,
            :coin_id,
            :transaction_id,
            presence: true

  validates :liability,
            :available,
            numericality: { only_integer: true }
end
