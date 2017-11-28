# frozen_string_literal: true

require "rails_helper"

describe MemberCoinEvent, type: :model, transactions: true do
  let(:member) { create :member }
  let(:bitcoin) { create :bitcoin }

  let(:member_coin_event) do
    lambda do |liability|
      build :member_coin_event, member: member,
                                system_transaction: SystemTransaction.new,
                                coin: bitcoin,
                                liability: liability
    end
  end

  let(:with_bitcoin) do
    create :member_coin_event, member: member,
                               system_transaction: SystemTransaction.new,
                               coin: bitcoin,
                               liability: 1000000000
  end

  describe "#member_coin_liability" do
    context "liability positive" do
      it "is valid" do
        event = member_coin_event.call(100000000)
        expect(event).to be_valid
      end
    end

    context "liability negative" do
      context "sufficient member liability" do
        it "is valid" do
          with_bitcoin
          event = member_coin_event.call(-100000000)
          expect(event).to be_valid
        end
      end

      context "insufficient member liability" do
        it "is invalid" do
          event = member_coin_event.call(-1000000000)
          expect(event).to_not be_valid
        end
      end
    end
  end

  describe "readonly" do
    context "update" do
      it "raises error" do
        event = member_coin_event.call(2).tap(&:save)
        event.liability = 2
        expect{ event.save }.to raise_error ActiveRecord::ReadOnlyRecord
      end
    end
  end
end
