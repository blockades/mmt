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

  validates :liability,
            presence: true

  validates :liability, numericality: { only_integer: true }

  validates_associated :member

  validate :member_coin_liability

  private

  def member_coin_liability
    return true if liability.positive? || (member.liability(coin.id) - liability.abs).positive?
    self.errors.add :liability, "Insufficient funds"
  end
end
