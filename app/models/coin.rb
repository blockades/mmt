# frozen_string_literal: true

class Coin < ApplicationRecord
  include AggregateRoot

  extend FriendlyId
  friendly_id :code, use: :slugged

  scope :ordered, -> { order(:code) }
  scope :crypto, -> { where(crypto_currency: true) }
  scope :fiat, -> { where.not(crypto_currency: true) }
  scope :not_self, ->(coin_id) { where.not(id: coin_id) }

  attr_readonly :code

  validates :code, uniqueness: { case_sensitive: true },
                   format: { with: /\A[a-zA-Z0-9_\.]*\Z/ },
                   exclusion: { in: MagicMoneyTree::InaccessibleWords.all }

  validates :slug, uniqueness: { case_sensitive: true }

  validates :subdivision, :code, presence: true
  validates :subdivision, numericality: { greater_than_or_equal_to: 0 }

  # ===> Publishing Events

  def stream
    "Domain::Coin$#{id}"
  end

  def transaction_history
    Rails.application.config.event_store.read_events_forward(stream)
  end

  def publish!(event_class, attributes = {})
    self.load(stream)
    apply event_class.new(data: attributes)
    self.store
  end

  # ===> Central Reserve and Live Holdings

  def holdings
    transaction_history.any? ? transaction_history.last.data.fetch(:holdings) : 0
  end

  def reserves
    transaction_history.any? ? transaction_history.last.data.fetch(:reserves) : 0
  end

  # ===> Live value and rate

  def value(iso_currency)
    btc_rate * 1.0 / fiat_btc_rate(iso_currency)
  end

  # @return The amount of this currency that buys one BTC
  def btc_rate
    crypto_currency ? crypto_btc_rate : fiat_btc_rate
  end

  class << self
    def crypto_with_balance(member)
      crypto.select { |coin| !member.holdings(coin.id).zero? }
    end

    def fiat_with_balance(member)
      fiat.select { |coin| !member.holdings(coin.id).zero? }
    end
  end

  private

  # Handler methods
  def apply_state(event)
    Rails.logger.info("\n\n#{event.inspect}\n\n")
  end

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
    # %%TODO%% We need a way to deal with missing codes so it doesn't cascade through and break the system
    # raise BittrexError, "Bittrex does not supply rates for #{code}" unless coins_by_bittrex.include? code
    bittrex_rates["result"].compact.find do |market|
      market["MarketName"] == "BTC-#{code}"
    end["Bid"]
  end

  def coins_by_bittrex
    bittrex_rates["result"].compact.map do |market|
      market["MarketName"].split('-').last
    end
  end

  def ensure_subdivision_multiple_of_ten
    return unless subdivision
    return unless (subdivision % 10).zero?
    errors.add :subdivision, "must be a multiple of 10"
  end
end
