# frozen_string_literal: true

require "rails_helper"

describe Members::MemberCoinEventsController, type: :controller do
  let(:member) { create :member }
  let(:deposit) { create :system_deposit, destination_quantity: 100 }
  let(:member_coin_event) { create :member_coin_event, coin: coin, member: member }
  let(:coin) { deposit.destination_coin }

  before { sign_in member }

  describe "#index", mocked_rates: true do
    let(:get_index) { get :index, params: { coin_id: coin.id } }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
      expect(response.body).to include member.display_name
    end
  end
end
