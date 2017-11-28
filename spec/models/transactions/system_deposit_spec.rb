# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemDeposit, type: :model, transactions: true do
  let(:bitcoin) { create :bitcoin }
  let(:system_deposit) { build :system_deposit, destination: bitcoin }
  let(:store_invalid_event!) { build(:coin_event, assets: -10 * 10**bitcoin.subdivision, coin: bitcoin).tap {|e| e.save(validate: false) } }

  include_examples "market rates"

  describe "hooks" do
    # describe "#publish_to_source" do
    #   context "valid" do
    #     it "creates admin coin event" do
    #       expect{ system_deposit.save }.to change{ AdminCoinEvent.count }.by(1)
    #     end
    #   end

    #   context "invalid" do
    #     before { store_invalid_event! }

    #     it "throws abort" do
    #       expect{ system_deposit.send(:publish_to_source) }.to throw_symbol(:abort)
    #     end

    #     it "fails to save" do
    #       expect(system_deposit.save).to be_falsey
    #     end
    #   end
    # end

    describe "#publish_to_destination" do
      context "valid" do
        it "creates coin event" do
          expect{ system_deposit.save }.to change{ CoinEvent.count }.by(1)
        end
      end

      context "invalid" do
        before { store_invalid_event! }

        it "throws abort" do
          expect{ system_deposit.send(:publish_to_destination) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(system_deposit.save).to be_falsey
        end
      end
    end
  end
end

