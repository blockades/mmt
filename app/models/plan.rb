# frozen_string_literal: true

class Plan < ApplicationRecord
  has_many :details, -> { where type: "PlanDetail" }, dependent: :destroy
  has_many :user_plans
  has_many :holdings, through: :user_plans

  accepts_nested_attributes_for :details, allow_destroy: true

  validates :name, uniqueness: true
  validate :sum_detail_proportion

  private

  def sum_detail_proportion
    unless details.sum(&:proportion) == 100
      errors.add(:total_detail_proportion, "Detail proportion sum must equal 100")
    end
  end
end
