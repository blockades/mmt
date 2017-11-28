# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemAllocation, transactions: true do
  let(:member) { create :member }
  let(:bitcoin) { create :bitcoin }
  let(:system_allocation) { build :system_allocation, source: bitcoin, destination: member }

  include_examples "market rates"

  describe "hooks" do
    context "valid" do
      include_examples "system with bitcoin", assets: 5

      describe "#publish_to_source" do
        it "creates coin event" do
          expect{ system_allocation.save }.to change{ CoinEvent.count }.by(1)
        end
      end

      describe "#publish_to_destination" do
        it "creates member coin event" do
          expect{ system_allocation.save }.to change{ MemberCoinEvent.count }.by(1)
        end
      end
    end

    context "invalid" do
      let(:bitcoin) { create :bitcoin }
      let(:store_invalid_event!) { build(:coin_event, assets: -10 * 10**bitcoin.subdivision, coin: bitcoin).tap {|e| e.save(validate: false) } }

      before { store_invalid_event! }

      describe "#publish_to_source" do
        it "throws abort" do
          expect{ system_allocation.send(:publish_to_source) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(system_allocation.save).to be_falsey
        end
      end

      describe "#publish_to_destination" do
        it "throws abort" do
          expect{ system_allocation.send(:publish_to_source) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(system_allocation.save).to be_falsey
        end
      end
    end
  end
end

