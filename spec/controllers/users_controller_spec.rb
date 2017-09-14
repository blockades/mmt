# frozen_string_literal: true

require "./spec/rails_helper"

describe UsersController do
  describe "#index" do
    let(:get_index) { get :index }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
    end

    it "assigns @users" do
      expect { get_index }.to change { assigns :users }
    end

    it "renders the index template" do
      expect(get_index).to render_template :index
    end
  end
end
