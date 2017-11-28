# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemWithdrawl, transactions: true do
  let(:system_withdrawl) { build :system_withdrawl, source: bitcoin }

  include_examples "market rates"

  describe "hooks" do
    context "valid" do
      include_examples "system with bitcoin", assets: 5
      include_examples "member with bitcoin", liability: 2

      describe "#publish_to_source" do
        it "creates coin event" do
          expect{ system_withdrawl.save }.to change{ CoinEvent.count }.by(1)
        end
      end

      # describe "#publish_to_destination" do
      #   it "creates admin coin event" do
      #     expect{ system_withdrawl.save }.to change{ AdminCoinEvent.count }.by(1)
      #   end
      # end
    end

    context "invalid" do
      let(:bitcoin) { create :bitcoin }
      let(:store_invalid_event!) { build(:member_coin_event, liability: -10 * 10**bitcoin.subdivision, coin: bitcoin).tap {|e| e.save(validate: false) } }

      before { store_invalid_event! }

      describe "#publish_to_source" do
        it "throws abort" do
          expect{ system_withdrawl.send(:publish_to_source) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(system_withdrawl.save).to be_falsey
        end
      end

      # describe "#publish_to_destination" do
      #   it "throws abort" do
      #     expect{ system_withdrawl.send(:publish_to_source) }.to throw_symbol(:abort)
      #   end

      #   it "fails to save" do
      #     expect(system_withdrawl.save).to be_falsey
      #   end
      # end

    end
  end
end

