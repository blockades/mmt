# frozen_string_literal: true

require "./spec/rails_helper"

describe Members::HoldingsController do
  let(:member) { create :member, :admin }

  before { sign_in member }

  describe "#index" do
    let(:get_index) { get :index }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
    end

    it "assigns @holdings" do
      expect { get_index }.to change { assigns :holdings }
    end

    it "renders the index template" do
      expect(get_index).to render_template :index
    end
  end
end
