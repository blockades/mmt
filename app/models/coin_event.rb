# frozen_string_literal: true

class CoinEvent < ApplicationRecord
  include Eventable

  belongs_to :coin
  belongs_to :system_transaction

  scope :credit, -> { where("assets > 0") }
  scope :debit, -> { where("assets < 0") }

  validates :assets,
            presence: true

  validates :assets, numericality: { only_integer: true }

  validates_associated :coin

  validate :coin_assets

  private

  def coin_assets
    return true if assets.positive? || (coin.assets - assets.abs).positive?
    self.errors.add :assets, "Insufficient assets"
  end
end
