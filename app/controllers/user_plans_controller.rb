class UserPlansController < ApplicationController

  def new
    @user_plan = UserPlan.new
  end

  def create
    context = CalculateHoldings.call(user_plan_params: user_plan_params)
    if context.success?
      flash[:notice] = context.message
      redirect_to holdings_path
    else
      flash[:error] = context.error
      redirect_to new_user_plan_path
    end
  end

  private

  def user_plan_params
    params.require(:user_plan).permit(:user_id, :plan_id, :iso_currency, :iou, :amount)
  end

end
