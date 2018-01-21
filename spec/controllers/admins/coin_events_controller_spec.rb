# frozen_string_literal: true

require "rails_helper"

describe Admins::CoinEventsController, type: :controller do
  let(:admin) { create :member, :admin }
  let(:coin_event) { create :asset_event }
  let(:coin) { coin_event.coin }

  before { sign_in admin }

  describe "#index", mocked_rates: true do
    let(:get_index) { get :index, params: { coin_id: coin.id } }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
    end
  end
end
