# frozen_string_literal: true

class Detail < ApplicationRecord
  scope :plan, -> { where type: "PlanDetail" }

  class << self
    def types
      [:plan]
    end
  end
end
