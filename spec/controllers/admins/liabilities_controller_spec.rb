# frozen_string_literal: true

require "rails_helper"

describe Admins::LiabilitiesController, type: :controller do
  let(:admin) { create :member, :admin }
  let(:deposit) { create :system_deposit, destination_quantity: 100 }
  let!(:allocation) { create :system_allocation, source_coin: coin, destination_quantity: 1 }
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
