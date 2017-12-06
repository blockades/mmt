# frozen_string_literal: true

require "rails_helper"

describe Members::FallbackSmsController, type: :controller do
  include_examples "with member"

  before do
    sign_in member
    reauthenticate!
  end

  describe "GET new" do
    let(:get_new) { get :new }

    it "returns a 200" do
      get_new
      expect(response.status).to eq 200
    end

    it "assigns @member" do
      expect { get_new }.to change { assigns :member }
    end

    it "renders the setup template" do
      expect(get_new).to render_template :new
    end
  end
end
