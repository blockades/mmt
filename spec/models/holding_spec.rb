# frozen_string_literal: true

require "./spec/rails_helper"

describe Asset do
  context "with existing assets" do
    let(:existing_portfolio) { create :portfolio, :with_assets }
    let(:existing_asset) { existing_portfolio.assets.first }
    let(:coin) { existing_asset.coin }
    let(:max_buyable_quantity) { coin.max_buyable_quantity }
    subject { build :asset, quantity: coin.central_reserve_in_sub_units + 1, coin: coin }

    it "must not take the assets over the central reserve" do
      expect(subject).to_not be_valid
      expect(subject.errors.to_a).to eq ["Quantity must be less than #{max_buyable_quantity}"]
    end
  end
end
