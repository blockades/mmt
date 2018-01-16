# frozen_string_literal: true

module Admins
  class WithdrawlRequestsController < AdminsController
    include TransactionHelper

    before_action :find_withdrawl_request, only: [:processing, :cancel, :complete, :revert]
    before_action :find_previous_transaction, only: [:complete]
    before_action :check_previous_transaction, only: [:complete]

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
      if @withdrawl_request.complete!(withdrawl_request_params)
        redirect_to admins_withdrawl_requests_path, notice: "Success"
      else
        redirect_to admins_withdrawl_requests_path, alert: "Failed"
      end
    end

    private

    def check_previous_transaction
      return if previous_transaction?
      return redirect_back fallback_location: new_exchange_path,
                           alert: "Invalid previous transaction"
    end

    def find_withdrawl_request
      @withdrawl_request = WithdrawlRequest.find(params[:id])
    end

    def permitted_params
      params.require(:withdrawl_request).permit(:previous_transaction_id)
    end

    def find_previous_transaction
      @previous_transaction = @withdrawl_request.previous_transaction
    end

    def withdrawl_request_params
      { member: current_member }
    end
  end
end
