# frozen_string_literal: true

require "rails_helper"

describe Transactions::MemberExchange, transactions: true do
  let(:admin) { create :member, :admin }
  let(:exchange) { build :member_exchange }
  let(:member) { exchange.source }
  let(:bitcoin) { exchange.source_coin }
  let(:sterling) { exchange.destination_coin }

  describe "hooks", mocked_rates: true do
    before do
      create :system_deposit, {
        source: admin,
        destination: bitcoin,
        destination_quantity: Utils.to_integer(5, bitcoin.subdivision),
        initiated_by: admin
      }
      create :system_deposit, {
        source: admin,
        destination: sterling,
        destination_quantity: Utils.to_integer(10_000, sterling.subdivision),
        initiated_by: admin
      }
      create :system_allocation, {
        source: admin,
        destination: member,
        source_coin: bitcoin,
        destination_coin: bitcoin,
        destination_quantity: Utils.to_integer(2, bitcoin.subdivision),
        destination_rate: bitcoin.btc_rate,
        initiated_by: admin
      }
    end

    it "creates liability event" do
      expect { exchange.save }.to change { member.liability_events.count }.by(2)
    end

    describe "#publish_to_source" do
      it "debits source (member) source_coin" do
        expect { exchange.save }.to change { member.liability(bitcoin) }.by(-exchange.source_quantity)
      end

      it "source_coin assets stay same" do
        expect { exchange.save }.to_not change { bitcoin.assets }
      end

      it "source_coin equity increases" do
        expect { exchange.save }.to_not change { bitcoin.equity }
      end
    end

    describe "#publish_to_destination" do
      it "credits destination (member) destination_coin" do
        expect { exchange.save }.to change { member.liability(sterling) }.by exchange.destination_quantity
      end

      it "destination_coin assets stay same" do
        expect { exchange.save }.to_not change { sterling.assets }
      end

      it "destination_coin equity stay same" do
        expect { exchange.save }.to_not change { sterling.equity }
      end
    end
  end

  describe "invalid", mocked_rates: true do
    context "insufficient coin assets" do
      before do
        create :system_deposit, {
          source: admin,
          destination: bitcoin,
          destination_quantity: Utils.to_integer(5, bitcoin.subdivision),
          initiated_by: admin
        }
        create :system_deposit, {
          source: admin,
          destination: sterling,
          destination_quantity: Utils.to_integer(5_000, sterling.subdivision),
          initiated_by: admin
        }
        create :system_allocation, {
          source: admin,
          destination: member,
          source_coin: bitcoin,
          destination_coin: bitcoin,
          destination_quantity: Utils.to_integer(2, bitcoin.subdivision),
          destination_rate: bitcoin.btc_rate,
          initiated_by: admin
        }
        exchange.source_quantity = Utils.to_integer(1, bitcoin.subdivision)
        exchange.destination_quantity = Utils.to_integer(5_000, sterling.subdivision)
      end

      it "is invalid" do
        expect(exchange.save).to be_falsey
      end
    end

    context "insufficient member liability" do
      before do
        create :system_deposit, {
          source: admin,
          destination: bitcoin,
          destination_quantity: Utils.to_integer(5, bitcoin.subdivision)
        }
        create :system_deposit, {
          source: admin,
          destination: sterling,
          destination_quantity: Utils.to_integer(10_000, sterling.subdivision)
        }
        exchange.source_quantity = Utils.to_integer(10, bitcoin.subdivision)
        exchange.destination_quantity = Utils.to_integer(50_000, sterling.subdivision)
      end

      it "is invalid" do
        expect(exchange.save).to be_falsey
      end
    end
  end
end
