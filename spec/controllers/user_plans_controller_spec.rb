# frozen_string_literal: true

require "./spec/rails_helper"

describe UserPlansController do
  describe "#new" do
    let(:get_new) { get :new }

    it "returns a 200" do
      get_new
      expect(response.status).to eq 200
    end

    it "assigns @user" do
      expect { get_new }.to change { assigns :user_plan }
    end

    it "renders the new template" do
      expect(get_new).to render_template :new
    end
  end
end
