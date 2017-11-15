# frozen_string_literal: true

module Admins
  class WithdrawlRequestsController < AdminsController
    before_action :find_withdrawl_request, except: [:index]

    def index
      @withdrawl_requests = WithdrawlRequest.outstanding
    end

    def history
      if @withdrawl_requests = WithdrawlRequest.all
        head :ok
      else
        head 403
      end
    end

    def progress
      if progress_withdrawl.success?
        head :ok
      else
        head 403
      end
    end

    def confirm
      if confirm_withdrawl.success?
        head :ok
      else
        head 403
      end
    end

    def cancel
      if cancel_withdrawl.success?
        head :ok
      else
        head 403
      end
    end

    private

    def find_withdrawl_request
      @withdrawl_request = WithdrawlRequest.find params[:id]
    end

    def progress_withdrawl
      @progress_withdrawl ||= ProgressWithdrawl.call(
        member_id: current_member.id,
        withdrawl_request_id: @withdrawl_request.id,
      )
    end

    def confirm_withdrawl
      @confirm_withdrawl ||= ConfirmWithdrawl.call(
        member_id: current_member.id,
        withdrawl_request_id: @withdrawl_request.id
      )
    end

    def cancel_withdrawl
      @cancel_withdrawl ||= CancelWithdrawl.call(
        member_id: current_member.id,
        withdrawl_request_id: @withdrawl_request.id
      )
    end
  end
end
