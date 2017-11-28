# frozen_string_literal: true

require "rails_helper"

describe Transactions::MemberAllocation, transactions: true do
  let(:member) { create :member }
  let(:destination) { create :member }
  let(:bitcoin) { create :bitcoin }
  let(:member_allocation) { build :member_allocation, source: member, destination: destination, source_coin: bitcoin }

  include_examples "market rates"

  describe "hooks" do
    context "valid" do
      include_examples "system with bitcoin", assets: 5
      include_examples "member with bitcoin", liability: 2

      describe "#publish_to_source" do
        it "creates member coin event" do
          expect{ member_allocation.save }.to change{ member.member_coin_events.count }.by(1)
        end
      end

      describe "#publish_to_destination" do
        it "creates member coin event" do
          expect{ member_allocation.save }.to change{ destination.member_coin_events.count }.by(1)
        end
      end
    end

    context "invalid" do
      let(:bitcoin) { create :bitcoin }

      let(:store_invalid_event!) do
        build(:member_coin_event,
          member: member,
          liability: -10 * 10**bitcoin.subdivision,
          coin: bitcoin
        ).tap {|e| e.save(validate: false) }
      end

      before { store_invalid_event! }

      describe "#publish_to_source" do
        it "throws abort" do
          expect{ member_allocation.send(:publish_to_source) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(member_allocation.save).to be_falsey
        end
      end

      describe "#publish_to_destination" do
        it "throws abort" do
          expect{ member_allocation.send(:publish_to_source) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(member_allocation.save).to be_falsey
        end
      end

    end
  end
end

