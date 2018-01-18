# frozen_string_literal: true

require "rails_helper"

describe Coin, type: :model do
  it "#live_holdings_quantity" do
  end

  it "#central_reserve" do
  end

  describe "#btc_rate", mocked_rates: true do
    let(:coin) { create :coin, crypto_currency: crypto_currency, code: code }
    let(:crypto_currency) { true }

    context "for a fiat currency" do
      let(:crypto_currency) { false }
      let(:code) { "GBP" }

      it "asks coinbase for the rate" do
        expect(coin.btc_rate).to eq 0.0002
      end
    end

    context "for a crypto currency" do
      let(:code) { "ETH" }

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
