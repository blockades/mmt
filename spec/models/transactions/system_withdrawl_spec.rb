# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemWithdrawl, transactions: true do
  let(:admin) { create :member, :admin }
  let(:subject) { build :system_withdrawl }
  let(:bitcoin) { subject.source }

  describe "hooks", mocked_rates: true do
    context "valid" do
      before do
        create :system_deposit, {
          source: admin,
          destination: bitcoin,
          destination_quantity: Utils.to_integer(5, bitcoin.subdivision)
        }
      end

      describe "#publish_to_source" do
        it "creates asset event" do
          expect { subject.save }.to change { bitcoin.asset_events.count }.by(1)
        end

        it "debits source (coin) assets" do
          assets = bitcoin.assets
          expect { subject.save }.to change { bitcoin.assets }.from(assets).to(assets - subject.source_quantity)
        end

        it "source_coin equity decreases" do
          equity = bitcoin.equity
          expect { subject.save }.to change { bitcoin.equity }.from(equity).to(equity - subject.source_quantity)
        end
      end

      # describe "#publish_to_destination" do
      #   it "creates equity event" do
      #     expect { subject.save }.to change { admin.equit_events.count }.by(1)
      #   end
      # end
    end

    context "invalid" do
      describe "#publish_to_source" do
        before { allow_any_instance_of(Events::Asset).to receive(:save).and_return(false) }

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end

      # describe "#publish_to_destination" do
      #   it "fails to save" do
      #     expect(subject.save).to be_falsey
      #   end
      # end
    end
  end
end
