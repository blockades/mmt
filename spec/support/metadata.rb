# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:example) do |example|
    if example.metadata[:mocked_rates]
      stub_request(:get, "https://bittrex.com/api/v1.1/public/getmarketsummaries").to_return(
        status: 200, headers: { "Content-Type" => "application/json" },
        body: json_fixture("market_rates")
      )
      stub_request(:get, "https://api.coinbase.com/v2/exchange-rates").with(query: { currency: "BTC" }).to_return(
        status: 200, headers: { "Content-Type" => "application/json" },
        body: json_fixture("bitcoin_to_sterling_rate")
      )

      stub_request(:get, "https://bittrex.com/api/v1.1/public/getmarketsummaries").to_return(
        status: 200, headers: { "Content-Type" => "application/json" },
        body: json_fixture("market_rates")
      )
    end
    example.run
  end
end
