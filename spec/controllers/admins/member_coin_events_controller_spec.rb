# frozen_string_literal: true

require "rails_helper"

describe Admins::MemberCoinEventsController, type: :controller do
  let(:admin) { create :member, :admin }
  let(:deposit) { create :system_deposit, destination_quantity: 100 }
  let(:member_coin_event) { create :member_coin_event, coin: coin }
  let(:coin) { deposit.destination_coin }

  before { sign_in admin }

  describe "#index", mocked_rates: true do
    let(:get_index) { get :index, params: { coin_id: coin.id } }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
    end
  end
end
