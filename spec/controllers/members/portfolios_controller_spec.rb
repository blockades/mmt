# frozen_string_literal: true

require "./spec/rails_helper"

describe Members::PortfoliosController do
  let(:portfolio) { create :portfolio }
  let(:member) { portfolio.member }

  before { sign_in member }

  describe "#show" do
    let(:get_show) { get :show, params: { id: portfolio.id } }

    it "returns a 200" do
      get_show
      expect(response.status).to eq 200
    end

    it "assigns @holdings" do
      expect { get_show }.to change { assigns :portfolio }
    end

    it "renders the show template" do
      expect(get_show).to render_template :show
    end
  end
end
