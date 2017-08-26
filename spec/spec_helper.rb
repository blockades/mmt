# frozen_string_literal: true

require 'simplecov'
require 'webmock/rspec'

SimpleCov.start 'rails' do
  add_filter '/app/channels'
  add_filter '/app/jobs'
end

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed

  config.around(:example) do |example|
    if example.metadata[:mocked_rates]
      @btc_eth_bid = 0.08
      stub_request(:get, "https://bittrex.com/api/v1.1/public/getmarketsummaries").to_return(
        status: 200, headers: { "Content-Type" => "application/json" },
        body: <<~JSON
          {"success":true,"message":"",
           "result":[{
             "MarketName":"BTC-ETH","High":0.078526,"Low":0.078477,"Volume":6000,"Last":0.076,"BaseVolume":4570.2,"Bid":#{@btc_eth_bid},"Ask":0.09,"OpenBuyOrders":3700,"OpenSellOrders":1000,"PrevDay":0.08
             }]
          }
        JSON
      )
    end
    example.run
  end
end
