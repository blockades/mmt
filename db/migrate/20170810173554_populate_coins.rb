class PopulateCoins < ActiveRecord::Migration[5.0]

  def self.up
    coins.each do |coin|
      Coin.create name: coin[:name], code: coin[:code]
    end
  end

  def self.down
    Coin.where(name: coins.map{|c| c[:name]}, code: coins.map{|c| c[:code]}).destroy_all
  end

  private

  def coins
    [
      { name: 'Bitcoin', code: 'BTC' },
      { name: 'Ethereum', code: 'ETH' },
      { name: 'AntShares', code: 'ANS' }
    ]
  end
end
