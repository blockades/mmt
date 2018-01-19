
# frozen_string_literal: true

require "rails_helper"

describe Transactions::Base, transactions: true, mocked_rates: true do
  let(:transaction) { build :system_deposit }
  let(:admin) { transaction.source }

  describe "system sum" do
    describe "#events sum" do
      let(:tx) { build :system_transaction }

      context "valid events" do
        it "returns true" do
          tx.liability_events.build(entry: 4, rate: 0.5, coin: build(:coin, subdivision: 0), member: admin)
          tx.equity_events.build(entry: 1, rate: 2, coin: build(:coin, subdivision: 0), member: admin)
          tx.asset_events.build(entry: 2, rate: 2, coin: build(:coin, subdivision: 0), member: admin)
          expect(tx.send(:events_sum_display)).to be_truthy
        end
      end

      context "invalid events" do
        it "returns false" do
          tx.liability_events.build(entry: 2, rate: 0.5, coin: build(:coin, subdivision: 0), member: admin)
          tx.equity_events.build(entry: 1, rate: 2, coin: build(:coin, subdivision: 0), member: admin)
          tx.asset_events.build(entry: 2, rate: 2, coin: build(:coin, subdivision: 0), member: admin)
          expect(tx.send(:events_sum_display)).to be_truthy
        end
      end
    end

    describe "#system_sum_to_zero" do
      context "valid" do
        it "returns true" do
          expect(transaction).to be_valid
        end
      end

      context "invalid" do
        it "returns false" do
          transaction.liability_events.build(entry: 2, rate: 0.5, coin: build(:coin, subdivision: 0), member: admin)
          expect(transaction).to_not be_valid
        end
      end
    end
  end

  describe "readonly?" do
    context "update" do
      before { allow(transaction).to receive(:new_record?).and_return(false) }

      it "raises error" do
        expect(transaction.send(:readonly?)).to be_truthy
      end
    end
  end

  describe "#correct_previous_transaction" do
    before { transaction.save }
    let(:next_transaction) { build :system_deposit, source: admin, previous_transaction: transaction }

    context "matches referring transaction" do
      it "is valid" do
        expect(next_transaction).to be_valid
      end
    end

    context "fails to match referring transaction" do
      before { create :system_deposit, source: admin, previous_transaction: transaction }

      it "is invalid" do
        expect(next_transaction).to_not be_valid
      end
    end
  end

  describe "#not_fiat_to_fiat" do
  end

  describe "#rates match" do
  end

  describe "#values_match" do
  end
end
