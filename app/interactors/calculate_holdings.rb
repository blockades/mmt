# frozen_string_literal: true

class CalculateHoldings
  include Interactor

  def call
    member_plan = MemberPlan.create(context.member_plan_params)
    if member_plan.persisted?
      if member_plan.calculate_holdings
        context.member_plan = member_plan
        context.message = "Success"
      else
        context.fail!(error: "ePiC fAiL!")
      end
    else
      context.fail!(error: "ePiC fAiL!")
    end
  end
end
