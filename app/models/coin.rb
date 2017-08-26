# frozen_string_literal: true

class Coin < ApplicationRecord
  has_many :holdings
  has_many :live_portfolios, -> { live }, through: :holdings, source: :portfolio
  has_many :live_holdings, through: :live_portfolios, class_name: "Holding", source: :holdings

  attr_readonly :code

  validates :code, uniqueness: true
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

  def max_buyable_quantity
    central_reserve_in_sub_units - live_holdings_quantity
  end

  private

  # %%TODO%% Extract API logic into PORO (Plain old ruby object) and initializers
  # Is this another model? CoinTimestamp
  # We need to be able to deal with
  # - Coin rebranding eg. ANS => NEO

  def fiat_btc_rate(iso_currency = nil)
    1.0 / BigDecimal.new(
      HTTParty.get("https://api.coinbase.com/v2/exchange-rates?currency=BTC")
      .parsed_response["data"]["rates"][iso_currency || code]
    )
  end

  def crypto_btc_rate
    return 1.0 if code == "BTC"
    response = HTTParty.get("https://bittrex.com/api/v1.1/public/getmarketsummaries").parsed_response["result"]
    response.find do |market|
      market["MarketName"] == "BTC-#{code}"
    end["Bid"]
  end

  def ensure_subdivision_multiple_of_ten
    return unless subdivision
    return unless (subdivision % 10).zero?
    errors.add :subdivision, "must be a multiple of 10"
  end
end
