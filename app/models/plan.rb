class Plan < ApplicationRecord

  has_many :details, ->{ where type: 'Plan' }
  has_many :user_plans
  has_many :holdings, through: :user_plans

  validates_uniqueness_of :name
end
