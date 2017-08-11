class UserPlan < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  has_many :holdings

  after_commit :calculate_holdings, on: :create

  private

  def calculate_holdings
    plan.details.each do |detail|
      holdings.create coin_id: detail.coin.id, amount: amount * ( detail.rate / 100 )
    end
  end
end
