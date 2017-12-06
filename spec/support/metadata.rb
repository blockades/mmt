# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:example) do |example|
    if example.metadata[:mocked_rates]
      @btc_eth_bid = 0.08
      stub_request(:get, "https://bittrex.com/api/v1.1/public/getmarketsummaries").to_return(
        status: 200, headers: { "Content-Type" => "application/json" },
        body: json_fixture("market_rates")
      )
    end
    example.run
  end
end
