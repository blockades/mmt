# frozen_string_literal: true

require "rails_helper"

describe CoinEvent, type: :model, transactions: true do
  let(:bitcoin) { create :bitcoin }
  let(:transaction) { SystemTransaction.new }

  let(:coin_event) do
    lambda do |assets|
      build :coin_event, system_transaction: transaction,
                         coin: bitcoin,
                         assets: assets
    end
  end

  let(:with_bitcoin) do
    create :coin_event, system_transaction: transaction,
                        coin: bitcoin,
                        assets: 1000000000
  end

  describe "#coin_assets" do
    context "assets positive" do
      it "is valid" do
        event = coin_event.call(100000000)
        expect(event).to be_valid
      end
    end

    context "assets negative" do
      context "sufficient system assets" do
        it "is valid" do
          with_bitcoin
          event = coin_event.call(-100000000)
          expect(event).to be_valid
        end
      end

      context "insufficient system assets" do
        it "is invalid" do
          event = coin_event.call(-1000000000)
          expect(event).to_not be_valid
        end
      end
    end
  end

  describe "readonly" do
    context "update" do
      it "raises error" do
        event = coin_event.call(100000000).tap(&:save)
        event.assets = 2
        expect{ event.save }.to raise_error ActiveRecord::ReadOnlyRecord
      end
    end
  end
end
