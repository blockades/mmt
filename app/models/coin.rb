# frozen_string_literal: true

class Coin < ApplicationRecord
  extend FriendlyId
  friendly_id :code, use: :slugged

  has_many :holdings
  has_many :live_portfolios, -> { live }, through: :holdings, source: :portfolio
  has_many :live_holdings, through: :live_portfolios, class_name: "Holding", source: :holdings

  scope :ordered, -> { order(:code) }

  attr_readonly :code

  validates :code, uniqueness: true
  validate :code_against_inaccessible_words
  validates :subdivision, :code, presence: true
  validates :subdivision, numericality: { greater_than_or_equal_to: 0 }
  validates :central_reserve_in_sub_units, numericality: { greater_than: :live_holdings_quantity }

  # %%TODO%% This is not a long term solution
  def value(iso_currency)
    btc_rate * 1.0 / fiat_btc_rate(iso_currency)
  end

  # @return The amount of this currency that buys one BTC
  def btc_rate
    crypto_currency ? crypto_btc_rate : fiat_btc_rate
  end

  def central_reserve
    BigDecimal.new(central_reserve_in_sub_units) / 10**subdivision
  end

  # @return <Integer> The value of the live holdings
  def live_holdings_quantity
    live_holdings.sum(:quantity) || 0
  end

  def live_holdings_quantity_display
    live_holdings_quantity / 10**subdivision
  end

  def max_buyable_quantity
    central_reserve_in_sub_units - live_holdings_quantity
  end

  private

  def fiat_btc_rate(iso_currency = nil)
    1.0 / BigDecimal.new(
      coinbase_rates["data"]["rates"][iso_currency || code]
    )
  end

  def coinbase_rates
    Rails.cache.fetch("coinbase_rates", expires_in: 30.minutes, race_condition_ttl: 5.seconds) do
      HTTParty.get("https://api.coinbase.com/v2/exchange-rates?currency=BTC").parsed_response
    end
  end

  def bittrex_rates
    Rails.cache.fetch("bittrex_rates", expires_in: 30.minutes, race_condition_ttl: 5.seconds) do
      HTTParty.get("https://bittrex.com/api/v1.1/public/getmarketsummaries").parsed_response
    end
  end

  def crypto_btc_rate
    return 1.0 if code == "BTC"
    bittrex_rates["result"].compact.find do |market|
      market["MarketName"] == "BTC-#{code}"
    end["Bid"]
  end

  def ensure_subdivision_multiple_of_ten
    return unless subdivision
    return unless (subdivision % 10).zero?
    errors.add :subdivision, "must be a multiple of 10"
  end

  def code_against_inaccessible_words
    errors.add(:code, :invalid) if MagicMoneyTree::InaccessibleWords.all.include? code.downcase
  end
end
