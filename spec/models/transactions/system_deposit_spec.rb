# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemDeposit, type: :model, transactions: true do
  let(:subject) { build :system_deposit }
  let(:bitcoin) { subject.destination }
  let(:admin) { subject.source }

  describe "hooks", mocked_rates: true do
     describe "#publish_to_source" do
       context "valid" do
         it "creates equity event" do
           expect { subject.save }.to change { admin.equity_events.count }.by(1)
         end

         it "credits source (admin) equity" do
           equity = admin.equity(bitcoin)
           expect { subject.save }.to change { admin.equity(bitcoin) }.from(equity).to(
             equity + subject.destination_quantity
           )
         end

         it "credits source_coin equity" do
           equity = bitcoin.equity
           expect { subject.save }.to change { bitcoin.equity }.from(equity).to(
             equity + subject.destination_quantity
           )
         end
       end

       context "invalid" do
         before { allow_any_instance_of(Events::Equity).to receive(:save).and_return(false) }

         it "fails to save" do
           expect(subject.save).to be_falsey
         end
       end
     end

    describe "#publish_to_destination" do
      context "valid" do
        it "creates asset event" do
          expect { subject.save }.to change { bitcoin.asset_events.count }.by(1)
        end

        it "credits source (coin) assets" do
          assets = bitcoin.assets
          expect { subject.save }.to change { bitcoin.assets }.from(assets).to(
            assets + subject.destination_quantity
          )
        end

        it "source_coin equity increases" do
          equity = bitcoin.equity
          expect { subject.save }.to change { bitcoin.equity }.from(equity).to(
            equity + subject.destination_quantity
          )
        end
      end

      context "invalid" do
        before { allow_any_instance_of(Events::Asset).to receive(:save).and_return(false) }

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end
    end
  end
end
