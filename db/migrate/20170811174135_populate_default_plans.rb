class PopulateDefaultPlans < ActiveRecord::Migration[5.0]
  def self.up
    plans.each do |plan|
      Plan.create(name: plan[:name]).tap do |p|
        plan[:details].each do |detail|
          p.details.create(coin_id: detail[:coin_id], rate: detail[:rate])
        end
      end
    end
  end

  def self.down
    Plan.where(name: plans.map{|p| p[:name]}).destroy_all
  end

  private

  def ans
    @ans ||= Coin.find_by(code: 'ANS')
  end

  def btc
    @btc ||= Coin.find_by(code: 'BTC')
  end

  def eth
    @eth ||= Coin.find_by(code: 'ETH')
  end

  def plans
    [
      { name: 'High', details: [ { coin_id: ans.id, rate: 100.00 } ] },
      { name: 'Medium', details: [ { coin_id: ans.id, rate: 33.34 }, { coin_id: eth.id, rate: 33.33 }, { coin_id: btc.id, rate: 33.33 } ] },
      { name: 'Low', details: [ { coin_id: btc.id, rate: 50.00 }, { coin_id: eth.id, rate: 50.00 } ] }
    ]
  end

end
