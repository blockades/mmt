# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemAllocation, transactions: true do
  include_examples "with member"
  include_examples "with bitcoin"

  let(:subject) { build :system_allocation, source: bitcoin, destination: member }

  describe "polymorphism" do
    it_behaves_like "source is a coin"
    it_behaves_like "destination is a member"
  end

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
      let(:store_invalid_event!) do
        build(:coin_event,
          assets: Utils.to_integer(-10, bitcoin.subdivision),
          coin: bitcoin
        ).tap {|e| e.save(validate: false) }
      end

      before { store_invalid_event! }

      describe "#publish_to_source" do
        it "throws abort" do
          expect{ subject.send(:publish_to_source) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end

      describe "#publish_to_destination" do
        it "throws abort" do
          expect{ subject.send(:publish_to_source) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end
    end
  end
end

