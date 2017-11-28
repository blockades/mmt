# frozen_string_literal: true

require "rails_helper"

describe Transactions::MemberExchange, transactions: true do

  include_examples "market rates"

  let(:build_exchange) do
    -> (attributes = {}) { build(:member_exchange, { source: member, source_coin: bitcoin, destination_coin: sterling }.merge(attributes) ) }
  end

  describe "hooks" do
    include_examples "system with bitcoin", assets: 5
    include_examples "system with sterling", assets: 10000
    include_examples "member with bitcoin", liability: 2

    let(:exchange) { build_exchange.call }

    describe "source and destination" do
      it "is an instance of Member" do
        expect(exchange.source).to be_an_instance_of Member
      end

      it "matches destination" do
        expect(exchange.source).to eq exchange.destination
      end
    end

    describe "#publish_to_source" do
      it "debits source (member) source_coin" do
        liability = (member.liability(bitcoin) / 10**bitcoin.subdivision).to_i
        expect(liability).to eq 2
        exchange.save
        liability = (member.reload.liability(bitcoin) / 10**bitcoin.subdivision).to_i
        expect(liability).to eq 1
      end
    end

    describe "#publish_to_destination" do
      it "credits source (member) destination_coin" do
        liability = (member.liability(sterling) / 10**sterling.subdivision).to_i
        expect(liability).to eq 0
        exchange.save
        liability = (member.reload.liability(sterling) / 10**sterling.subdivision).to_i
        expect(liability).to eq 5000
      end
    end

    describe "#publish_to_destination_coin" do
      it "debits system destination coin" do
        assets = (sterling.assets / 10**sterling.subdivision).to_i
        expect(assets).to eq 10000
        exchange.save
        assets = (sterling.reload.assets / 10**sterling.subdivision).to_i
        expect(assets).to eq 5000
      end
    end

    describe "#publish_to_source_coin" do
      it "credits system source coin" do
        assets = (bitcoin.assets / 10**bitcoin.subdivision).to_i
        expect(assets).to eq 3
        exchange.save
        assets = (bitcoin.reload.assets / 10**bitcoin.subdivision).to_i
        expect(assets).to eq 4
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
        expect{ exchange.send(:publish_to_destination_coin) }.to throw_symbol(:abort)
      end

      it "is invalid" do
        expect(exchange.save).to be_falsey
        expect(exchange.tap(&:valid?).errors).to include :coin_events
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
