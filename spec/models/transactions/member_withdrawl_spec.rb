# frozen_string_literal: true

require "rails_helper"

describe Transactions::MemberWithdrawl, transactions: true do
  let(:member) { create :member }
  let(:bitcoin) { create :bitcoin }
  let(:member_withdrawl) { build :member_withdrawl, source: member, destination: bitcoin }

  include_examples "market rates"

  describe "hooks" do
    context "valid" do
      include_examples "system with bitcoin", assets: 5
      include_examples "member with bitcoin", liability: 2

      describe "#publish_to_source" do
        it "creates coin event" do
          expect{ member_withdrawl.save }.to change{ CoinEvent.count }.by(1)
        end
      end

      describe "#publish_to_destination" do
        it "creates member coin event" do
          expect{ member_withdrawl.save }.to change{ MemberCoinEvent.count }.by(1)
        end
      end
    end

    context "invalid" do
      let(:bitcoin) { create :bitcoin }
      let(:store_invalid_event!) { build(:member_coin_event, liability: -10 * 10**bitcoin.subdivision, coin: bitcoin).tap {|e| e.save(validate: false) } }

      before { store_invalid_event! }

      describe "#publish_to_source" do
        it "throws abort" do
          expect{ member_withdrawl.send(:publish_to_source) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(member_withdrawl.save).to be_falsey
        end
      end

      describe "#publish_to_destination" do
        it "throws abort" do
          expect{ member_withdrawl.send(:publish_to_source) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(member_withdrawl.save).to be_falsey
        end
      end

    end
  end
end

