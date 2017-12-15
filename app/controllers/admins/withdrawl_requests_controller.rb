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
      result = ::WithdrawlRequests::Process.call(
        member: current_member,
        withdrawl_request: @withdrawl_request
      )

      if result.success?
        redirect_to admins_withdrawl_requests_path, notice: result.message
      else
        redirect_to admins_withdrawl_requests_path, alert: result.message
      end
    end

    def revert
      result = ::WithdrawlRequests::Revert.call(
        member: current_member,
        withdrawl_request: @withdrawl_request
      )

      if result.success?
        redirect_to admins_withdrawl_requests_path, notice: result.message
      else
        redirect_to admins_withdrawl_requests_path, alert: result.message
      end
    end

    def cancel
      result = ::WithdrawlRequests::Cancel.call(
        member: current_member,
        withdrawl_request: @withdrawl_request
      )

      if result.success?
        redirect_to admins_withdrawl_requests_path, notice: result.message
      else
        redirect_to admins_withdrawl_requests_path, alert: result.message
      end
    end

    def complete
      unless previous_transaction?
        return redirect_back fallback_location: admins_withdrawl_request_path(@withdrawl_request), alert: "Invalid previous transaction"
      end

      result = ::WithdrawlRequests::Complete.call(
        member: current_member,
        withdrawl_request: @withdrawl_request,
        previous_transaction: @previous_transaction
      )

      if result.success?
        redirect_to admins_withdrawl_requests_path, notice: result.message
      else
        redirect_to admins_withdrawl_requests_path, alert: result.message
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
  end
end
