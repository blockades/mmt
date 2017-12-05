# frozen_string_literal: true

require "rails_helper"

describe CoinEvent, type: :model, transactions: true do
  include_examples "with bitcoin"

  let(:coin_event) do
    build :coin_event, coin: bitcoin,
                       assets: Utils.to_integer(10, bitcoin.subdivision)
  end

  describe "#coin_assets" do
    let(:coin_assets) { coin_event.send(:coin_assets) }

    context "assets positive" do
      it "returns true" do
        expect(coin_assets).to be_truthy
      end
    end

    context "assets negative" do
      before { coin_event.assets = Utils.to_integer(-10, bitcoin.subdivision) }

      context "sufficient system assets" do
        it "returns true" do
          expect(coin_assets).to be_truthy
        end
      end

      context "insufficient system assets" do
        it "adds an error" do
          expect(coin_assets).to include "Insufficient assets"
        end
      end
    end
  end

  describe "readonly" do
    include_examples "system with bitcoin", assets: 5
    let(:event) { CoinEvent.last }

    context "update" do
      it "returns false" do
        expect(event.send(:readonly?)).to be_truthy
      end
    end
  end
end
