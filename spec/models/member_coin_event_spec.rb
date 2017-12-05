# frozen_string_literal: true

require "rails_helper"

describe MemberCoinEvent, type: :model, transactions: true do
  include_examples "with member"
  include_examples "with bitcoin"

  let(:member_coin_event) do
    build :member_coin_event, member: member,
                              coin: bitcoin,
                              liability: Utils.to_integer(10, bitcoin.subdivision)
  end

  describe "#member_coin_liability" do
    let(:member_coin_liability) { member_coin_event.send(:member_coin_liability) }

    context "liability positive" do
      it "returns true" do
        expect(member_coin_liability).to be_truthy
      end
    end

    context "liability negative" do
      before { member_coin_event.liability = Utils.to_integer(-10, bitcoin.subdivision) }

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
    include_examples "system with bitcoin", assets: 5
    include_examples "member with bitcoin", liability: 2
    let(:event) { MemberCoinEvent.last }

    context "update" do
      it "returns false" do
        expect(event.send(:readonly?)).to be_truthy
      end
    end
  end
end
