class UserPlan < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  has_many :holdings

  after_commit :calculate_holdings, on: :create

  private

  def high_risk_amount
    amount
  end

  def medium_risk_amount
    amount / 3
  end

  def low_risk_amount
    amount / 2
  end

  def calculate_holdings
    Coin.send(plan.name.downcase.to_sym).each do |coin|
      holdings.create coin_id: coin.id, amount: self.send("#{plan.name.downcase}_risk_amount".to_sym)
    end
  end
end
