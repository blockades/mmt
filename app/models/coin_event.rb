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
            :transaction_id,
            presence: true

  validates :liability,
            :available,
            numericality: { only_integer: true }

  validate :coin_liability

  private

  def coin_liability
    return true if liability.abs < coin.reload.available
    self.errors.add :destination_quantity, "Insufficient funds"
  end
end
