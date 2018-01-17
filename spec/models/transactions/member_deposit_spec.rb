# frozen_string_literal: true

require "rails_helper"

describe Transactions::MemberDeposit, transactions: true do
  let(:admin) { create :member, :admin }
  let(:subject) { build :member_deposit }
  let(:bitcoin) { subject.source }
  let(:member) { subject.destination }

  describe "hooks", mocked_rates: true do
    context "valid" do
      before do
        create :system_deposit, {
          source: admin,
          destination: bitcoin,
          destination_quantity: Utils.to_integer(5, bitcoin.subdivision)
        }
        create :system_allocation, {
          source: bitcoin,
          destination: member,
          source_coin: bitcoin,
          destination_coin: bitcoin,
          destination_quantity: Utils.to_integer(2, bitcoin.subdivision),
          destination_rate: bitcoin.btc_rate,
          initiated_by: admin
        }
      end

      it "source_coin equity stays the same" do
        expect { subject.save }.to_not change { bitcoin.equity }
      end

      describe "#publish_to_source" do
        it "creates asset event" do
          expect { subject.save }.to change { bitcoin.asset_events.count }.by(1)
        end

        it "credits source (coin) assets" do
          assets = bitcoin.assets
          expect { subject.save }.to change { bitcoin.assets }.from(assets).to(
            assets + subject.destination_quantity
          )
        end
      end

      describe "#publish_to_destination" do
        it "creates liability event" do
          expect { subject.save }.to change { member.liability_events.count }.by(1)
        end

        it "credits destination (member) destination_coin liability" do
          liability = member.liability(bitcoin)
          expect { subject.save }.to change { member.liability(bitcoin) }.from(liability).to(
            liability + subject.destination_quantity
          )
        end
      end
    end

    context "invalid" do
      describe "#publish_to_source" do
        before { allow_any_instance_of(Events::Asset).to receive(:save).and_return(false) }

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end

      describe "#publish_to_destination" do
        before { allow_any_instance_of(Events::Liability).to receive(:save).and_return(false) }

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end
    end
  end
end
