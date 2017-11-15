# frozen_string_literal: true

class ProgressWithdrawl
  include Interactor

  def call
    context.fail(message: "Failed") unless mark_as_in_progress!
    context.message = "Withdrawl request now in progress"
  end

  private

  def mark_as_in_progress!
    ActiveRecord::Base.transaction do
      withdrawl_request.last_changed_by_id = member.id
      withdrawl_request.in_progress_by_id = member.id
      withdrawl_request.progress
    end
  end

  def member
    @member ||= ::Member.find context.member_id
  end

  def withdrawl_request
    @withdrawl_request ||= ::WithdrawlRequest.find context.withdrawl_request_id
  end
end
