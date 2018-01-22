# frozen_string_literal: true

require "rails_helper"

describe Admins::AssetsController, type: :controller do
  let(:admin) { create :member, :admin }
  let(:deposit) { create :system_deposit }
  let(:coin) { deposit.destination_coin }

  before { sign_in admin }

  describe "#index", mocked_rates: true do
    let(:get_index) { get :index, params: { coin_id: coin.id } }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
      expect(response.body).to include deposit.initiated_by.display_name
    end
  end
end
