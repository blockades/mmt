# frozen_string_literal: true

require "./spec/rails_helper"

describe MembersController do
  describe "#index" do
    let(:get_index) { get :index }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
    end

    it "assigns @members" do
      expect { get_index }.to change { assigns :members }
    end

    it "renders the index template" do
      expect(get_index).to render_template :index
    end
  end
end
