class UserPlansController < ApplicationController

  def new
    @user_plan = UserPlan.new
  end

  def create
    user_plan = UserPlan.new(user_plan_params)
    if user_plan.save
      flash[:notice] = "Success"
    else
      flash[:error] = "ePiC fAiL!"
    end
    redirect_to new_user_plan_path
  end

  private

  def user_plan_params
    params.require(:user_plan).permit(:user_id, :plan_id, :iso_currency, :iou, :amount)
  end

end
