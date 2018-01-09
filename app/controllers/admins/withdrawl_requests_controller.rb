# frozen_string_literal: true

module Admins
  class WithdrawlRequestsController < AdminsController
    include TransactionHelper

    before_action :find_withdrawl_request, only: [:processing, :cancel, :complete, :revert]
    before_action :find_previous_transaction, only: [:complete]

    def index
      @withdrawl_requests = WithdrawlRequest.all.decorate
    end

    def processing
      if @withdrawl_request.process!(withdrawl_request_params)
        redirect_to admins_withdrawl_requests_path, notice: "Success"
      else
        redirect_to admins_withdrawl_requests_path, alert: "Failed"
      end
    end

    def cancel
      if @withdrawl_request.cancel!(withdrawl_request_params)
        redirect_to admins_withdrawl_requests_path, notice: "Success"
      else
        redirect_to admins_withdrawl_requests_path, alert: "Failed"
      end
    end

    def complete
      unless previous_transaction?
        return redirect_back fallback_location: admins_withdrawl_request_path(@withdrawl_request), alert: "Invalid previous transaction"
      end

      if @withdrawl_request.complete!(complete_params)
        redirect_to admins_withdrawl_requests_path, notice: "Success"
      else
        redirect_to admins_withdrawl_requests_path, alert: "Failed"
      end
    end

    private

    def find_withdrawl_request
      @withdrawl_request = WithdrawlRequest.find(params[:id])
    end

    def find_previous_transaction
      @previous_transaction = Transactions::MemberWithdrawl.ordered.for_source(@withdrawl_request.member).last
    end

    def permitted_params
      params.require(:withdrawl_request).permit(:previous_transaction_id)
    end

    def withdrawl_request_params
      { member: current_member }
    end

    def complete_params
      withdrawl_request_params.merge(previous_transaction: @previous_transaction)
    end
  end
end
