# frozen_string_literal: true

require "rails_helper"

describe Members::DepositsController, type: :controller do
  let(:member) { create :member }
  let(:coin) { create :coin }

  before { sign_in member }

  describe "GET new" do
    let(:get_new) { get :new, params: { coin_id: coin.id } }

    it "returns 200" do
      get_new
      expect(response.status).to eq 200
    end

    it "renders template :new" do
      expect(get_new).to render_template :new
    end

    it "assigns @coin" do
      expect { get_new }.to change { assigns :coin }.to(coin)
    end

    context "with a previous transaction" do
      it "assigns @previous_transaction" do
        expect { get_new }.to_not change { assigns :previous_transaction }
      end
    end

    context "without a previous transaction", mocked_rates: true do
      let!(:previous_transaction) { create :member_deposit, destination: member }

      it "assigns @previous_transaction" do
        expect { get_new }.to change { assigns :previous_transaction }.to(previous_transaction)
      end
    end
  end

  shared_examples "a new deposit", mocked_rates: true do
    it "creates a new transaction" do
      expect { post_create }.to change { Transactions::MemberDeposit.count }.by(1)
    end
  end

  describe "POST create" do
    let(:deposit_params) { { destination_quantity: Utils.to_integer(1, coin.subdivision) } }
    let(:post_create) { post :create, params: { coin_id: coin.id, deposit: deposit_params } }

    context "with a previous transaction" do
      let!(:previous_transaction) { create :member_deposit, destination: member }
      before { deposit_params.merge!(previous_transaction_id: previous_transaction.id) }

      it_behaves_like "a new deposit"

      context "incorrect previous_transaction id" do
        before { deposit_params.merge(previous_transaction_id: SecureRandom.uuid) }

        it "redirects back" do
          post_create
          expect(response.status).to eq 302
        end
      end
    end

    context "without a previous transaction" do
      it_behaves_like "a new deposit"
    end
  end
end
