# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemDeposit, type: :model, transactions: true do
  include_examples "with bitcoin"

  let(:subject) { build :system_deposit, destination: bitcoin }

  describe "polymorphism" do
    it_behaves_like "source is a member"
    it_behaves_like "destination is a coin"
  end

  describe "hooks" do
    let(:store_invalid_event!) do
      build(:coin_event,
        assets: -10 * 10**bitcoin.subdivision,
        coin: bitcoin
      ).tap {|e| e.save(validate: false) }
    end

    # describe "#publish_to_source" do
    #   context "valid" do
    #     it "creates admin coin event" do
    #       expect{ subject.save }.to change{ admin.admin_coin_events.count }.by(1)
    #     end
    #   end

    #   context "invalid" do
    #     before { store_invalid_event! }

    #     it "throws abort" do
    #       expect{ subject.send(:publish_to_source) }.to throw_symbol(:abort)
    #     end

    #     it "fails to save" do
    #       expect(subject.save).to be_falsey
    #     end
    #   end
    # end

    describe "#publish_to_destination" do
      context "valid" do
        it "creates coin event" do
          expect{ subject.save }.to change{ bitcoin.coin_events.count }.by(1)
        end
      end

      context "invalid" do
        before { store_invalid_event! }

        it "throws abort" do
          expect{ subject.send(:publish_to_destination) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end
    end
  end
end

