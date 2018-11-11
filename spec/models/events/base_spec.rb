# frozen_string_literal: true

require "rails_helper"

describe Events::Base, type: :model, events: true do
  let(:event) { build :event, :with_coin }

  describe "rates", mocked_rates: true do
    describe "#btc_value" do
      it "returns the rate times the entry" do
        expect(event.btc_value).to eq(event.rate * event.entry)
      end
    end

    describe "#btc_value_display" do
      it "returns value as decimal" do
        value_display = (event.rate * event.entry) / 10**event.coin.subdivision
        expect(event.btc_value_display).to eq(value_display)
      end
    end
  end

  describe "readonly?" do
    context "update" do
      before { allow(event).to receive(:new_record?).and_return(false) }

      it "raises error" do
        expect(event.send(:readonly?)).to be_truthy
      end
    end
  end
end
