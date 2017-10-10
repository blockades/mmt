# frozen_string_literal: true

class MemberPlan < ApplicationRecord
  belongs_to :member
  belongs_to :plan

  has_many :holdings

  # %%TODO%% work out how to decouple this. Perhaps put into interactor / PORO?
  def calculate_holdings
    plan.details.each do |detail|
      holdings.create coin_id: detail.coin.id, amount: amount * (detail.proportion / 100)
    end
  end
end
