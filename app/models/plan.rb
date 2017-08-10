class Plan < ApplicationRecord

  has_many :user_plans
  has_many :holdings, through: :user_plans

  def high?
    name == 'high'
  end

  def medium?
    name == 'medium'
  end

  def low?
    name == 'low'
  end
end
