class Plan < ApplicationRecord

  has_many :details, ->{ where type: 'PlanDetail' }, dependent: :destroy
  has_many :user_plans
  has_many :holdings, through: :user_plans

  accepts_nested_attributes_for :details, allow_destroy: true

  validates_uniqueness_of :name
end
