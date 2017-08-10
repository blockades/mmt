class Coin < ApplicationRecord

  validates_uniqueness_of :code

  scope :high, -> { where(code: ['ANS']) }
  scope :medium, -> { where(code: ['BTC', 'ETH', 'ANS']) }
  scope :low, -> { where(code: ['BTC', 'ETH']) }

  def value(iso_currency)
    send("#{code.downcase}_value", iso_currency)
  end

  private

  # %%TODO%% Extract API logic into PORO (Plain old ruby object)
  def btc_value(iso_currency)
    BigDecimal.new HTTParty.get('https://api.coinbase.com/v2/exchange-rates?currency=BTC').parsed_response['data']['rates'][iso_currency]
  end

  def eth_value(iso_currency)
    BigDecimal.new HTTParty.get('https://api.coinbase.com/v2/exchange-rates?currency=ETH').parsed_response['data']['rates'][iso_currency]
  end

  def ans_value(iso_currency)
    response = HTTParty.get('https://bittrex.com/api/v1.1/public/getmarketsummaries').parsed_response['result']
    market = response.select do |market|
      market['MarketName'] == 'BTC-ANS'
    end
    btc_value(iso_currency) * BigDecimal.new(market.first['Last'].to_s)
  end

end
