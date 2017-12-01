# frozen_string_literal: true

require "rails_helper"

describe SystemTransaction, transactions: true do
  let(:admin) { create :admin }
  let(:transaction) { create :system_deposit, source: admin }

  include_examples "market rates"

  describe "readonly?" do
    context "update" do
      it "raises error" do
        transaction.source_id = SecureRandom.uuid
        expect { transaction.save }.to raise_error ActiveRecord::ReadOnlyRecord
      end
    end
  end

  describe "#correct_previous_transaction" do
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
