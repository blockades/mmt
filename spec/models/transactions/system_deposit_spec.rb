# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemDeposit, type: :model, transactions: true do
  include_examples "with bitcoin"

  let(:subject) { build :system_deposit, destination: bitcoin, destination_quantity: Utils.to_integer(1, bitcoin.subdivision) }

  describe "hooks" do
    # describe "#publish_to_source" do
    #   context "valid" do
    #     it "creates admin coin event" do
    #       expect { subject.save }.to change { admin.admin_coin_events.count }.by(1)
    #     end
    #   end

    #   context "invalid" do
    #     before { allow_any_instance_of(AdminCoinEvent).to receive(:save).and_return(false) }
    #
    #     it "fails to save" do
    #       expect(subject.save).to be_falsey
    #     end
    #   end
    # end

    describe "#publish_to_destination" do
      context "valid" do
        it "creates coin event" do
          expect { subject.save }.to change { bitcoin.coin_events.count }.by(1)
        end

        it "credits source (coin) assets" do
          assets = bitcoin.assets
          expect { subject.save }.to change { bitcoin.assets }.from(assets).to(assets + subject.destination_quantity)
        end

        it "source_coin equity increases" do
          equity = bitcoin.equity
          expect { subject.save }.to change { bitcoin.equity }.from(equity).to(equity + subject.destination_quantity)
        end
      end

      context "invalid" do
        before { allow_any_instance_of(CoinEvent).to receive(:save).and_return(false) }

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end
    end
  end
end
