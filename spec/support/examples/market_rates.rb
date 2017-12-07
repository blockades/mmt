# frozen_string_literal: true

RSpec.shared_examples "market rates" do
  before do
    stub_request(:get, "https://api.coinbase.com/v2/exchange-rates").with(query: { currency: "BTC" }).to_return(
      status: 200, headers: { "Content-Type" => "application/json" },
      body: json_fixture("bitcoin_to_sterling_rate")
    )

    stub_request(:get, "https://bittrex.com/api/v1.1/public/getmarketsummaries").to_return(
      status: 200, headers: { "Content-Type" => "application/json" },
      body: json_fixture("market_rates")
    )
  end
end
