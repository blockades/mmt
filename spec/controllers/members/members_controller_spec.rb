# frozen_string_literal: true

require "./spec/rails_helper"

describe Members::MembersController do
  let(:member) { create :member, :admin }

  before { sign_in member }

  describe "GET #show" do
    let(:get_show) { get :show, id: member.id }

    it "returns a 200" do
      get_show
      expect(response.status).to eq 200
    end

    it "assigns @members" do
      expect { get_show }.to change { assigns :member }
    end

    it "renders the index template" do
      expect(get_index).to render_template :show
    end
  end
end
