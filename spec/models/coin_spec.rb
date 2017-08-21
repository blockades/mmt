require 'rails_helper'

describe Coin, type: :model do
  it "#live_holdings_value" do
    subject = create :coin
    expect(subject.live_holdings_value).to eq 0

    create :holding, coin: subject, amount: 10
    create :holding, portfolio: (create :portfolio, :spent), coin: subject, amount: 20

    expect(subject.live_holdings_value).to eq 10
  end

  it '#central_reserve' do
    subject.assign_attributes(
      central_reserve_in_sub_units: 150,
      subdivision: 2
    )

    expect(subject.central_reserve).to eq 1.5

    subject.subdivision = 0

    expect(subject.central_reserve).to eq 150
  end
end
