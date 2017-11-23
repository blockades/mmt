# frozen_string_literal: true

class CoinEvent < ApplicationRecord

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

  validate :coin_liability, unless: :deposit_event?

  private

  def coin_liability
    return true if liability.abs < coin.reload.available
    self.errors.add :destination_quantity, "Insufficient funds"
  end

  def deposit_event?
    triggered_by.system_deposit?
  end
end
