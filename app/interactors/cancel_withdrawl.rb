# frozen_string_literal: true

class CancelWithdrawl
  include Interactor

  def call
    context.fail!(message: "Failed") unless cancel_withdrawl!
    context.message = "Withdrawl request cancelled"
  end

  private

  def cancel_withdrawl!
    ActiveRecord::Base.transaction do
      withdrawl_request.last_changed_by_id = member.id
      withdrawl_request.cancelled_by_id = member.id
      withdrawl_request.cancel
    end
  end

  def member
    @member ||= Member.find context.member_id
  end

  def withdrawl_request
    @withdrawl_request ||= ::WithdrawlRequest.find context.withdrawl_request_id
  end
end
