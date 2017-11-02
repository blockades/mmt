# frozen_string_literal: true

require 'rails_helper'

describe Members::SettingsController, type: :controller do
  let(:portfolio) { create :portfolio }
  let(:member) { portfolio.member }

  before do
    sign_in member
  end

  describe 'GET index' do
    let(:get_index) { get :index }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
    end

    it 'assigns @member' do
      expect{ get_index }.to change{ assigns :member }
    end

    it 'renders the setup template' do
      expect(get_index).to render_template :index
    end
  end
end
