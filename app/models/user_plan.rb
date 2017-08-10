class UserPlan < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  has_many :holdings

  accepts_nested_attributes_for :holdings
end
