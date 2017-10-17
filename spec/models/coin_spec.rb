# frozen_string_literal: true

require "rails_helper"

describe Coin, type: :model do

  it_behaves_like 'sluggable', :code

  it "#live_holdings_quantity" do
    subject = create :coin
    expect(subject.live_holdings_quantity).to eq 0

    create :holding, coin: subject, quantity: 10
    create :holding, portfolio: (create :portfolio, :spent), coin: subject, quantity: 20

    expect(subject.live_holdings_quantity).to eq 10
  end

  it "#central_reserve" do
    subject.assign_attributes(
      central_reserve_in_sub_units: 150,
      subdivision: 2
    )

    expect(subject.central_reserve).to eq 1.5

    subject.subdivision = 0

    expect(subject.central_reserve).to eq 150
  end

  describe "#btc_rate" do
    let(:coin) { create :coin, crypto_currency: crypto_currency, code: code }
    let(:crypto_currency) { true }

    context "for a fiat currency" do
      let(:crypto_currency) { false }
      let(:code) { "GBP" }
      before do
        stub_request(:get, "https://api.coinbase.com/v2/exchange-rates")
          .with(query: { currency: "BTC" })
          .to_return(
            status: 200, headers: { "Content-Type" => "application/json" },
            body: '{"data":{"rates":{"GBP":"3400.00"}}}'
          )
      end

      it "asks coinbase for the rate" do
        expect(coin.btc_rate).to eq(1.0 / BigDecimal.new("3400.00"))
      end
    end

    context "for a crypto currency" do
      let(:code) { "ETH" }
      before do
        stub_request(:get, "https://bittrex.com/api/v1.1/public/getmarketsummaries")
          .to_return(
            status: 200, headers: { "Content-Type" => "application/json" },
            body: json_fixture('market_rates') # '{"result":[{"MarketName":"BTC-ETH","Bid":0.08}]}'
          )
      end

      it "asks bittrex for the rate" do
        expect(coin.btc_rate).to eq 0.08
      end
    end

    context "for bitcoin" do
      let(:code) { "BTC" }

      it "is one" do
        expect(coin.btc_rate).to eq 1
      end
    end
  end
end
