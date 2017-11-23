# frozen_string_literal: true

class CoinEvent < ApplicationRecord
  include EventHelper

  belongs_to :coin
  belongs_to :triggered_by, class_name: 'Transaction::Base',
                            foreign_key: :transaction_id,
                            inverse_of: :coin_events

  def readonly?
    Rails.env.development? ? false : !new_record?
  end

  validates :liability,
            :available,
            :triggered_by,
            presence: true

  validates :liability,
            :available,
            numericality: { only_integer: true }

  validate :coin_liability, unless: proc { deposit_event? || exchange_event? }

  validate :exchange_liability, if: :exchange_event?

  private

  def coin_liability
    return true if liability.abs < coin.reload.available
    self.errors.add :liability, "Insufficient funds"
  end

  def exchange_liability
    if destination_coin_event?
      binding.pry
      return true if liability.abs < coin.reload.available
      self.errors.add :liability, "Insufficient funds"
    end
  end
end
