# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemAllocation, transactions: true do
  include_examples "with member"
  include_examples "with bitcoin"

  let(:subject) { build :system_allocation, source: bitcoin, destination: member }

  describe "hooks" do
    include_examples "market rates"

    context "valid" do
      include_examples "system with bitcoin", assets: 5

      describe "#publish_to_source" do
        it "creates coin event" do
          expect{ subject.save }.to change{ bitcoin.coin_events.count }.by(1)
        end

        it "credit source (coin) assets" do
          assets = bitcoin.assets
          expect{ subject.save }.to_not change{ bitcoin.assets }
        end
      end

      describe "#publish_to_destination" do
        it "creates member coin event" do
          expect{ subject.save }.to change{ member.member_coin_events.count }.by(1)
        end

        it "credits destination (member) destination_coin liability" do
          liability = member.liability(bitcoin)
          expect{ subject.save }.to change{ member.liability(bitcoin) }.from(liability).to(liability + subject.destination_quantity)
        end
      end
    end

    context "invalid" do
      before { allow_any_instance_of(MemberCoinEvent).to receive(:save).and_return(false) }

      describe "#publish_to_source" do
        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end

      describe "#publish_to_destination" do
        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end
    end
  end
end

