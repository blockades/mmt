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
      if @withdrawl_request.progress!(current_member.id)
        redirect_back fallback_location: admins_withdrawl_requests_path, notice: "Success"
      else
        redirect_back fallback_location: admins_withdrawl_requests_path, notice: "Fail"
      end
    end

    def confirm
      if @withdrawl_request.confirm!(current_member.id)
        redirect_back fallback_location: admins_withdrawl_requests_path, notice: "Success"
      else
        redirect_back fallback_location: admins_withdrawl_requests_path, notice: "Fail"
      end
    end

    def cancel
      if @withdrawl_request.cancel!(current_member.id)
        redirect_back fallback_location: admins_withdrawl_requests_path, notice: "Success"
      else
        redirect_back fallback_location: admins_withdrawl_requests_path, notice: "Fail"
      end
    end

    private

    def find_withdrawl_request
      @withdrawl_request = WithdrawlRequest.find params[:id]
    end
  end
end
