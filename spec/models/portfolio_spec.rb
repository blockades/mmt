require "rails_helper"

describe Portfolio, type: :model do
  let(:portfolio) { create :portfolio }
  let(:user) { portfolio.user }
  let(:next_portfolio) { build :portfolio, user: user }

  it "can only have one live portfolio per user" do
    expect { next_portfolio.save! }.to raise_error ActiveRecord::RecordNotUnique
  end

  it "sets the next_portfolio_at when setting the next_portfolio" do
    expect(portfolio.next_portfolio_at).to be_blank

    portfolio.update(next_portfolio: next_portfolio)

    expect(portfolio.reload.next_portfolio).to eq next_portfolio
    expect(portfolio.next_portfolio_at).to_not be_blank
  end
end
