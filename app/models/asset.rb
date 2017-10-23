# frozen_string_literal: true

class Asset < ApplicationRecord
  belongs_to :coin
  belongs_to :portfolio, inverse_of: :assets

  before_save :calculate_rate

  attr_readonly(:coin_id, :crypto, :initial_btc_rate,
                :deposit, :withdrawal, :portfolio_id)

  validates :coin, :portfolio, :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validate :ensure_less_than_central_reserve, on: :create

  scope :with_coins, -> { includes(:coin) }

  def btc_value
    coin.btc_rate * quantity
  end

  private

  def ensure_less_than_central_reserve
    return if coin && quantity < coin.max_buyable_quantity
    errors.add :quantity, "must be less than #{coin.max_buyable_quantity}"
  end

  def calculate_rate
    self.initial_btc_rate ||= coin.btc_rate
  end
end
