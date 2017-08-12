class PlansController < ApplicationController

  def index
    @plans = Plan.all
  end

  def new
    @plan = Plan.new
  end

  def create
    plan = Plan.new plan_params
    if plan.save
      redirect_to plans_path
    else
      flash[:error] = "ePic fAiL"
      redirect_to :back
    end
  end

  private

  def plan_params
    params.require(:plan).permit(:name, details_attributes: [ :id, :type, :coin_id, :plan_id, :rate ])
  end

end
