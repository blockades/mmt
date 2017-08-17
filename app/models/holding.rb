class Holding < ApplicationRecord
  belongs_to :coin
  belongs_to :portfolio

  before_save :calculate_rate

  attr_readonly(:coin_id, :crypto, :initial_btc_rate,
                :deposit, :withdrawal, :portfolio_id)

  private

  def calculate_rate
    self.initial_btc_rate = coin.btc_rate
  end
end
