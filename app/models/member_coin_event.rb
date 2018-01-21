# frozen_string_literal: true

class MemberCoinEvent < ApplicationRecord
  include Eventable

  belongs_to :coin
  belongs_to :member
  belongs_to :system_transaction

  scope :with_coin, ->(coin_id) { where coin_id: coin_id }
  scope :with_coins, -> { joins(:coin) }
  scope :crypto, -> { with_coins.merge(Coin.crypto) }
  scope :fiat, -> { with_coins.merge(Coin.fiat) }
  scope :credit, -> { where("liability > 0") }
  scope :debit, -> { where("liability < 0") }
  scope :ordered, -> { order(created_at: :desc) }

  validates :liability, presence: true,
                        numericality: { only_integer: true }

  validates_associated :member

  validate :coin_assets, :member_coin_liability

  def liability_display
    Utils.to_decimal(liability, coin.subdivision)
  end

  private

  def coin_assets
    return true if (coin.assets - liability.abs).positive?
    self.errors.add :assets, "Insufficient assets"
  end

  def member_coin_liability
    return true if liability.positive?
    member_liability = member.liability(coin) - liability.abs
    return true if member_liability.positive? || member_liability.zero?
    self.errors.add :liability, "Insufficient funds"
  end
end
