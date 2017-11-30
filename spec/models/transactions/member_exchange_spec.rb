# frozen_string_literal: true

require "rails_helper"

describe Transactions::MemberExchange, transactions: true do
  include_examples "with bitcoin"
  include_examples "with member"
  include_examples "with sterling"

  let(:build_exchange) do
    -> (attributes = {}) { build(:member_exchange, { source: member, source_coin: bitcoin, destination_coin: sterling }.merge(attributes) ) }
  end

  describe "polymorphism" do
    let(:subject) { build_exchange.call }

    it_behaves_like "source is a member"
    it_behaves_like "destination is a member"
  end

  describe "hooks" do
    include_examples "market rates"

    include_examples "system with bitcoin", assets: 5
    include_examples "system with sterling", assets: 10000
    include_examples "member with bitcoin", liability: 2

    let(:exchange) { build_exchange.call }

    it "creates member coin event" do
      expect{ exchange.save }.to change{ member.member_coin_events.count }.by(2)
    end

    describe "#publish_to_source" do
      it "debits source (member) source_coin" do
        expect{ exchange.save }.to change{ member.liability(bitcoin) }.by -exchange.source_quantity
      end

      it "source_coin assets stay same" do
        expect{ exchange.save }.to_not change{ bitcoin.assets }
      end

      it "source_coin equity increases" do
        equity = bitcoin.equity
        expect { exchange.save }.to change { bitcoin.equity }.from(equity).to(equity + exchange.source_quantity)
      end
    end

    describe "#publish_to_destination" do
      it "credits source (member) destination_coin" do
        expect{ exchange.save }.to change{ member.liability(sterling) }.by exchange.destination_quantity
      end

      it "destination_coin assets stay same" do
        expect{ exchange.save }.to_not change{ sterling.assets }
      end

      it "destination_coin equity decreases" do
        equity = sterling.equity
        expect{ exchange.save }.to change{ sterling.equity }.from(equity).to(equity - exchange.destination_quantity)
      end
    end
  end

  describe "invalid" do
    let(:exchange) { build_exchange.call(source_quantity: source_quantity, destination_quantity: destination_quantity )}

    context "insufficient coin assets" do
      include_examples "system with bitcoin", assets: 5
      include_examples "system with sterling", assets: 5000
      include_examples "member with bitcoin", liability: 2

      let(:source_quantity) { 1 * 10**bitcoin.subdivision }
      let(:destination_quantity) { 5000 * 10**sterling.subdivision }

      it "throws abort" do
        expect{ exchange.send(:publish_to_destination) }.to throw_symbol(:abort)
      end

      it "is invalid" do
        expect(exchange.save).to be_falsey
        expect(exchange.tap(&:valid?).errors).to include :member_coin_events
      end
    end

    context "insufficient member liability" do
      include_examples "system with bitcoin", assets: 5
      include_examples "system with sterling", assets: 10000
      include_examples "member with bitcoin", liability: 2

      let(:source_quantity) { 10 * 10**bitcoin.subdivision }
      let(:destination_quantity) { 50000 * 10**sterling.subdivision }

      it "throws abort" do
        expect{ exchange.send(:publish_to_source) }.to throw_symbol(:abort)
      end

      it "is invalid" do
        expect(exchange.save).to be_falsey
        expect(exchange.tap(&:valid?).errors).to include :member_coin_events
      end
    end
  end
end
