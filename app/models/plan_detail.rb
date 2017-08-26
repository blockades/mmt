# frozen_string_literal: true

class PlanDetail < Detail
  belongs_to :plan
  belongs_to :coin
end
