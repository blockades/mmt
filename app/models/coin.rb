class Coin < ApplicationRecord

  validates_uniqueness_of :code

  # %%TODO%% This is not a long term solution
  def value(iso_currency)
    value = send("#{code.downcase}_value", iso_currency)
  end

  private

  # %%TODO%% Extract API logic into PORO (Plain old ruby object) and initializers
  # Is this another model? CoinTimestamp
  # We need to be able to deal with
  # - Coin rebranding eg. ANS => NEO

  def btc_value(iso_currency)
    BigDecimal.new HTTParty.get('https://api.coinbase.com/v2/exchange-rates?currency=BTC').parsed_response['data']['rates'][iso_currency]
  end

  def eth_value(iso_currency)
    BigDecimal.new HTTParty.get('https://api.coinbase.com/v2/exchange-rates?currency=ETH').parsed_response['data']['rates'][iso_currency]
  end

  def ans_value(iso_currency)
    response = HTTParty.get('https://bittrex.com/api/v1.1/public/getmarketsummaries').parsed_response['result']
    market = response.select do |market|
      market['MarketName'] == 'BTC-NEO'
    end
    btc_value(iso_currency) * BigDecimal.new(market.first['Last'].to_s)
  end

end
