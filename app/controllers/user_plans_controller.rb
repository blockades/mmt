# frozen_string_literal: true

class MemberPlansController < ApplicationController
  def new
    @member_plan = MemberPlan.new
  end

  def create
    context = CalculateHoldings.call(member_plan_params: member_plan_params)
    if context.success?
      flash[:notice] = context.message
      redirect_to holdings_path
    else
      flash[:error] = context.error
      redirect_to new_member_plan_path
    end
  end

  private

  def member_plan_params
    params.require(:member_plan).permit(:member_id, :plan_id, :iso_currency, :iou, :amount)
  end
end
