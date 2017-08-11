require './spec/rails_helper'

describe Holding do
  let(:coin) { create :coin }
  let(:coin_value) { 3000.00 }

  describe '#calculate_holdings' do
    before do
      allow(coin).to receive(:value).and_return coin_value
    end

    let(:holding) { build :holding }
    let(:amount) { 350.00 }

    it 'executes as a hook' do
      expect(holding).to receive(:calculate_holdings)
      holding.save
    end

    it 'sets crypto value' do
      crypto_value = amount / coin_value
      expect{ holding.save }.to change{ holding.crypto }.from(nil).to(crypto_value)
    end

  end


end
