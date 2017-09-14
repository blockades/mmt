class PopulateCoins < ActiveRecord::Migration[5.0]

  def self.up
    values = coins.map do |coin|
      "('#{coin[:name]}', '#{coin[:code]}', current_timestamp, current_timestamp)"
    end.join(", ")

    insert "INSERT INTO coins (name, code, created_at, updated_at) VALUES #{values}"
  end

  def self.down
    Coin.where(name: coins.map{|c| c[:name]}, code: coins.map{|c| c[:code]}).destroy_all
  end

  private

  def coins
    [
      { name: 'Bitcoin', code: 'BTC' },
      { name: 'Ethereum', code: 'ETH' },
      { name: 'AntShares', code: 'NEO' }
    ]
  end
end
