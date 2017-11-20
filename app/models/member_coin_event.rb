class MemberCoinEvent < ApplicationRecord

  belongs_to :coin
  belongs_to :member

  scope :with_coin, ->(coin_id) { where coin_id: coin_id }
  scope :with_coins, -> { joins(:coin) }
  scope :crypto, -> { with_coins.where(coins: { crypto_currency: true }) }
  scope :fiat, -> { with_coins.where(coins: { crypto_currency: false }) }

  def readonly?
    !new_record?
  end

  validates :liability,
            :transaction_id,
            presence: true

  validates :liability, numericality: { only_integer: true }

end
