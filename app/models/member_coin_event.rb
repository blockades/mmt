class MemberCoinEvent < ApplicationRecord

  belongs_to :coin
  belongs_to :member

  scope :with_coin, ->(coin_id) { where coin_id: coin_id }
  scope :crypto, -> { joins(:coins).where(coins: { crypto_currency: true }) }
  scope :fiat, -> { joins(:coins).where(coins: { crypto_currency: false }) }

  attr_readonly :available,
                :coin_id,
                :member_id,
                :transaction_id

  validates :available,
            :coin_id,
            :member_id,
            :transaction_id,
            presence: true

  validates :available, numericality: { only_integer: true }

end
