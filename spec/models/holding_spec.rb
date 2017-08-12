require './spec/rails_helper'

describe Holding do
  let(:user_plan) { create :user_plan }
  let(:coin) { Coin.first }
  let(:coin_value) { BigDecimal.new '3000.00' }

  describe '#calculate_holdings' do
    before do
      allow(coin).to receive(:value).and_return coin_value
    end

    let(:amount) { BigDecimal.new '350.00' }
    let(:holding) { build :holding, amount: amount, coin_id: coin.id, user_plan_id: user_plan.id }

    it 'executes as a hook' do
      expect(holding).to receive(:calculate_crypto_value)
      holding.save
    end

    it 'sets crypto value' do
      crypto_value = amount / coin_value
      expect{ holding.save }.to change{ holding.crypto }.from(nil).to(crypto_value)
    end
  end

end
