# frozen_string_literal: true

require "rails_helper"

describe Events::Asset, type: :model, transactions: true do
  let(:asset_event) { build :asset_event }
  let(:bitcoin) { asset_event.coin }

  describe "#coin_assets" do
    let(:coin_assets) { asset_event.send(:coin_assets) }

    context "assets positive" do
      it "returns true" do
        expect(coin_assets).to be_truthy
      end
    end

    context "assets negative" do
      before { asset_event.entry = Utils.to_integer(-10, bitcoin.subdivision) }

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
    before do
      allow(asset_event).to receive(:new_record?).and_return(false)
    end

    context "update" do
      it "returns false" do
        expect(asset_event.send(:readonly?)).to be_truthy
      end
    end
  end
end
