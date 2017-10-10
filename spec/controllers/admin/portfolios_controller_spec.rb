# frozen_string_literal: true

require "rails_helper"

describe Admin::PortfoliosController do
  let(:member) { create :member, :admin }
  let(:resource) { create :portfolio, :with_holdings }

  before do
    sign_in member
  end

  it "GET index.html" do
    resource
    get :index
    expect(response.status).to eq 200
  end

  it "POST create.html" do
    portfolio_params = {
      member_id: resource.member_id,
      previous_portfolio_id: resource.id,
      holdings_attributes: [{
        coin_id: resource.holdings[0].coin_id,
        initial_btc_rate: 0.1,
        quantity: 10,
      }]
    }

    post :create, params: { portfolio: portfolio_params }

    created_portfolio = resource.reload.next_portfolio

    expect(response.status).to eq 302
    expect(created_portfolio).to be_a Portfolio
    expect(created_portfolio.holdings.count).to eq 1
    expect(created_portfolio.holdings[0].quantity).to eq 10
  end
end
