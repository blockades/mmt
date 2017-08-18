require './spec/rails_helper'

describe Holding do
  context "with existing holdings" do
    let(:existing_portfolio) { create :portfolio, :with_holdings }
    let(:existing_holding) { existing_portfolio.holdings.first }
    let(:coin) { existing_holding.coin }
    let(:max_buyable_quantity) { coin.max_buyable_quantity }
    subject { build :holding, quantity: coin.central_reserve_in_sub_units + 1, coin: coin }

    it 'must not take the holdings over the central reserve' do
      expect(subject).to_not be_valid
      expect(subject.errors.to_a).to eq ["Quantity must be less than #{max_buyable_quantity}"]
    end
  end
end
