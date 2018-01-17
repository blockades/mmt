# frozen_string_literal: true

require "rails_helper"

describe Transactions::MemberAllocation, transactions: true do
  let(:admin) { create :member, :admin }
  let(:subject) { build :member_allocation }
  let(:member) { subject.source }
  let(:destination) { subject.destination }
  let(:bitcoin) { subject.source_coin }

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

      it "source_coin assets stay same" do
        expect { subject.save }.to_not change { bitcoin.assets }
      end

      it "source_coin equity stays same" do
        expect { subject.save }.to_not change { bitcoin.equity }
      end

      describe "#publish_to_source" do
        it "creates liability event" do
          expect { subject.save }.to change { member.liability_events.count }.by(1)
        end

        it "debits source (member) source_coin" do
          expect { subject.save }.to change { member.liability(bitcoin) }.by(-subject.destination_quantity)
        end
      end

      describe "#publish_to_destination" do
        it "creates liability event" do
          expect { subject.save }.to change { destination.liability_events.count }.by(1)
        end

        it "credits destination (member) destination_coin" do
          expect { subject.save }.to change { destination.liability(bitcoin) }.by subject.destination_quantity
        end
      end
    end

    context "invalid" do
      before { allow_any_instance_of(Events::Liability).to receive(:save).and_return(false) }

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
