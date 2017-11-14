# frozen_string_literal: true

module Admins
  class WithdrawlRequestsController < AdminsController
    before_action :find_withdrawl_request, except: [:index]

    def index
      @withdrawl_requests = WithdrawlRequest.outstanding
    end

    def history
      @withdrawl_requests = WithdrawlRequest.all
    end

    def progress
      @withdrawl_request.progress!(current_member.id)
      head :ok
    end

    def confirm
      @withdrawl_request.confirm!(current_member.id)
      head :ok
    end

    def cancel
      @withdrawl_request.cancel!(current_member.id)
      head :ok
    end

    private

    def find_withdrawl_request
      @withdrawl_request = WithdrawlRequest.find params[:id]
    end
  end
end
