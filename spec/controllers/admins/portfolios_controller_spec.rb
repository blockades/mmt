# frozen_string_literal: true

require "rails_helper"

describe Admins::PortfoliosController do
  let(:resource) { create :portfolio, :with_assets }

  let(:member) { create :member, :admin }
  let(:json) { JSON.parse(response.body) }

  before do
    sign_in member
  end

  describe '#index' do
    let(:get_index) { get :index }

    it "returns a 200" do
      resource
      get_index
      expect(response.status).to eq 200
    end

    it 'assigns @portfolios' do
      expect{ get_index }.to change{ assigns :portfolios }
    end

    it 'renders index template' do
      expect(get_index).to render_template :index
    end
  end

  describe '#new' do
    let(:get_new) { get :new }

    it 'returns a 200' do
      get_new
      expect(response.status).to eq 200
    end

    it 'assigns @portfolio' do
      expect{ get_new }.to change{ assigns :portfolio }
    end

    it 'renders new template' do
      expect(get_new).to render_template :new
    end
  end

  describe '#show', mocked_rates: true do
    let(:get_show) { get :show, params: { id: resource.id, format: :json }}

    it 'returns a 200' do
      get_show
      expect(response.status).to eq 200
    end

    it 'assigns @portfolio' do
      expect{ get_show }.to change{ assigns :portfolio }
    end

    it 'renders JSON response' do
      get_show
      expect(json['id']).to eq resource.id
    end
  end

  describe '#create' do
    it "POST create.html" do
      portfolio_params = {
        member_id: resource.member_id,
        previous_portfolio_id: resource.id,
        assets_attributes: [{
          coin_id: resource.assets[0].coin_id,
          initial_btc_rate: 0.1,
          quantity: 10,
        }]
      }

      post :create, params: { portfolio: portfolio_params }

      created_portfolio = resource.reload.next_portfolio

      expect(response.status).to eq 302
      expect(created_portfolio).to be_a Portfolio
      expect(created_portfolio.assets.count).to eq 1
      expect(created_portfolio.assets[0].quantity).to eq 10
    end
  end
end

