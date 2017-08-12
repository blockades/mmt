class CalculateHoldings
  include Interactor

  def call
    user_plan = UserPlan.create(context.user_plan_params)
    if user_plan.persisted?
      if user_plan.calculate_holdings
        context.user_plan = user_plan
        context.message = "Success"
      else
        context.fail!(error: "ePiC fAiL!")
      end
    else
      context.fail!(error: "ePiC fAiL!")
    end
  end
end
