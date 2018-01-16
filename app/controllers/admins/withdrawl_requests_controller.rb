# frozen_string_literal: true

module Admins
  class WithdrawlRequestsController < AdminsController
    include TransactionHelper

    before_action :find_withdrawl_request, only: [:processing, :cancel, :complete, :revert]

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

      if @withdrawl_request.complete!(withdrawl_request_params)
        transaction = transaction_commiter(Transactions::MemberWithdrawl, @withdrawl_request.transaction_params)
        if transaction.persisted?
          redirect_to admins_withdrawl_requests_path, notice: "Success"
        else
          @withdrawl_request.fail!(withdrawl_request_params)
          redirect_to admins_withdrawl_requests_path, alert: "Failed"
        end
      else
        redirect_to admins_withdrawl_requests_path, alert: "Failed"
      end
    end

    private

    def find_withdrawl_request
      @withdrawl_request = WithdrawlRequest.find(params[:id])
    end

    def permitted_params
      params.require(:withdrawl_request).permit(:previous_transaction_id)
    end

    def withdrawl_request_params
      { member: current_member }
    end
  end
end
