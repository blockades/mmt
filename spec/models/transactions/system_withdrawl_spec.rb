# frozen_string_literal: true

require "rails_helper"

describe Transactions::SystemWithdrawl, transactions: true do
  include_examples "with bitcoin"

  let(:subject) { build :system_withdrawl, source: bitcoin }

  describe "polymorphism" do
    it_behaves_like "source is a coin"
    it_behaves_like "destination is a member"
  end

  describe "hooks" do
    include_examples "market rates"

    context "valid" do
      include_examples "system with bitcoin", assets: 5
      include_examples "member with bitcoin", liability: 2

      describe "#publish_to_source" do
        it "creates coin event" do
          expect{ subject.save }.to change{ bitcoin.coin_events.count }.by(1)
        end

        it "debits source (coin) assets" do
          assets = bitcoin.assets
          expect{ subject.save }.to change{ bitcoin.assets }.from(assets).to(assets - subject.source_quantity)
        end

        it "source_coin equity decreases" do
          equity = bitcoin.equity
          expect { subject.save }.to change { bitcoin.equity }.from(equity).to(equity - subject.source_quantity)
        end
      end

      # describe "#publish_to_destination" do
      #   it "creates admin coin event" do
      #     expect{ subject.save }.to change{ admin.admin_coin_events.count }.by(1)
      #   end
      # end
    end

    context "invalid" do
      let(:store_invalid_event!) do
        build(:member_coin_event,
          liability: -10 * 10**bitcoin.subdivision,
          coin: bitcoin
        ).tap {|e| e.save(validate: false) }
      end

      before { store_invalid_event! }

      describe "#publish_to_source" do
        it "throws abort" do
          expect{ subject.send(:publish_to_source) }.to throw_symbol(:abort)
        end

        it "fails to save" do
          expect(subject.save).to be_falsey
        end
      end

      # describe "#publish_to_destination" do
      #   it "throws abort" do
      #     expect{ subject.send(:publish_to_source) }.to throw_symbol(:abort)
      #   end

      #   it "fails to save" do
      #     expect(subject.save).to be_falsey
      #   end
      # end

    end
  end
end

