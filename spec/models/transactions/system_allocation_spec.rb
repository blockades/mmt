# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemAllocation, transactions: true do
  let(:subject) { build :system_allocation }
  let(:admin) { subject.source }
  let(:member) { subject.destination }
  let(:bitcoin) { subject.source_coin }

  describe "hooks", mocked_rates: true do
    context "valid" do
      before do
        create :system_deposit, {
          source: member,
          destination: bitcoin,
          destination_quantity: Utils.to_integer(5, bitcoin.subdivision),
          initiated_by: admin
        }
      end

      describe "#publish_to_source" do
        it "creates equity event" do
          expect { subject.save }.to change { admin.equity_events.count }.by(1)
        end

        it "debit source (admin) equity" do
          equity = admin.equity(bitcoin)
          expect { subject.save }.to change { admin.equity(bitcoin) }.from(equity).to(
            equity - subject.destination_quantity
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
        before { allow_any_instance_of(Events::Equity).to receive(:save).and_return(false) }

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
