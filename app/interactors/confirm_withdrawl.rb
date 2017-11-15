# frozen_string_literal: true

class ConfirmWithdrawl
  include Interactor

  def call
    context.fail!(message: "Failed") unless change_state_to_confirmed!
    context.message = "Confirmed withdrawl"
  end

  private

  def change_state_to_confirmed!
    ActiveRecord::Base.transaction do
      withdrawl_request.last_changed_by_id = member.id
      withdrawl_request.confirmed_by_id = member.id
      withdrawl_request.confirm
    end
  end

  def withdrawl_request
    @withdrawl_request ||= ::WithdrawlRequest.find context.withdrawl_request_id
  end

  def member
    @member ||= ::Member.find context.member_id
  end
end

