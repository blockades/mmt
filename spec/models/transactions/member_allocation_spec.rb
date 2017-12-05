# frozen_string_literal: true

require "rails_helper"

describe Transactions::MemberAllocation, transactions: true do
  include_examples "with bitcoin"
  include_examples "with member"
  include_examples "with sterling"

  let(:destination) { create :member }

  let(:subject) do
    build :member_allocation, source: member,
                              destination: destination,
                              source_coin: bitcoin
  end

  describe "hooks" do
    include_examples "market rates"

    context "valid" do
      include_examples "system with bitcoin", assets: 5
      include_examples "member with bitcoin", liability: 2

      it "source_coin assets stay same" do
        expect{ subject.save }.to_not change{ bitcoin.assets }
      end

      it "source_coin equity stays same" do
        expect { subject.save }.to_not change { bitcoin.equity }
      end

      describe "#publish_to_source" do
        it "creates member coin event" do
          expect{ subject.save }.to change{ member.member_coin_events.count }.by(1)
        end

        it "debits source (member) source_coin" do
          expect{ subject.save }.to change{ member.liability(bitcoin) }.by -subject.destination_quantity
        end
      end

      describe "#publish_to_destination" do
        it "creates member coin event" do
          expect{ subject.save }.to change{ destination.member_coin_events.count }.by(1)
        end

        it "credits destination (member) destination_coin" do
          expect{ subject.save }.to change{ destination.liability(bitcoin) }.by subject.destination_quantity
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

