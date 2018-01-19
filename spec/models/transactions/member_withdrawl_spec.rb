# frozen_string_literal: true

require "rails_helper"

describe Transactions::MemberWithdrawl, transactions: true do
  let(:admin) { create :member, :admin }
  let(:subject) { build :member_withdrawl }
  let(:member) { subject.source }
  let(:bitcoin) { subject.destination }

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

      describe "#publish_to_source" do
        it "creates member coin event" do
          expect { subject.save }.to change { member.member_coin_events.count }.by(1)
        end

        it "debits destination (member) destination_coin liability" do
          liability = member.liability(bitcoin)
          expect { subject.save }.to change { member.liability(bitcoin) }.from(liability).to(
            liability - subject.source_quantity
          )
        end
      end

      describe "#publish_to_destination" do
        it "creates coin event" do
          expect { subject.save }.to change { bitcoin.coin_events.count }.by(1)
        end

        it "debits source (coin) assets" do
          assets = bitcoin.assets
          expect { subject.save }.to change { bitcoin.assets }.from(assets).to(
            assets - subject.source_quantity
          )
        end
      end
    end

    context "invalid" do
      describe "#publish_to_source" do
        before { allow_any_instance_of(MemberCoinEvent).to receive(:save).and_return(false) }

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end

      describe "#publish_to_destination" do
        before { allow_any_instance_of(CoinEvent).to receive(:save).and_return(false) }

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end
    end
  end
end
