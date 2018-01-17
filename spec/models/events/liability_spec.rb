# frozen_string_literal: true

require "rails_helper"

describe Events::Liability, type: :model, transactions: true do
  let(:liability_event) { build :liability_event }
  let(:bitcoin) { liability_event.coin }
  let(:member) { liability_event.member }

  describe "#member_coin_liability" do
    let(:member_coin_liability) { liability_event.send(:member_coin_liability) }

    context "liability positive" do
      it "returns true" do
        expect(member_coin_liability).to be_truthy
      end
    end

    context "liability negative" do
      before { liability_event.entry = Utils.to_integer(-10, bitcoin.subdivision) }

      context "sufficient member liability" do
        it "returns true" do
          expect(member_coin_liability).to be_truthy
        end
      end

      context "insufficient member liability" do
        it "adds an error" do
          expect(member_coin_liability).to include "Insufficient funds"
        end
      end
    end
  end

  describe "readonly" do
    before do
      allow(liability_event).to receive(:new_record?).and_return(false)
    end

    context "update" do
      it "returns false" do
        expect(liability_event.send(:readonly?)).to be_truthy
      end
    end
  end
end
