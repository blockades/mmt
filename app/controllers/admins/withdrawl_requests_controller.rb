# frozen_string_literal: true

module Admins
  class WithdrawlRequestsController < AdminsController
    include TransactionHelper

    before_action :find_withdrawl_request, only: [:mark_as_processing, :cancel, :confirm]
    before_action :find_previous_transaction, only: [:new, :confirm]

    def index
      @withdrawl_requests = WithdrawlRequest.all.decorate
    end

    def update
      if @withdrawl_request.update withdrawl_request_params
        redirect_to admins_withdrawl_requests_path, notice: "Success"
      else
        redirect_to admins_withdrawl_request_path(@withdrawl_request), alert: "Fail"
      end
    end

    def mark_as_processing
      return unless @withdrawl_request.can_process?

      if @withdrawl_request.process
        redirect_to admins_coins_path, notice: "Success"
      else
        redirect_to admins_withdrawl_requests_path, alert: transaction.error_message
      end
    end

    def cancel
      return unless @withdrawl_request.can_cancel?

      if @withdrawl_request.cancel
        redirect_to admins_coins_path, notice: "Success"
      else
        redirect_to admins_withdrawl_requests_path, alert: transaction.error_message
      end
    end

    def confirm
      unless previous_transaction?
        return redirect_back fallback_location: admins_withdrawl_request_path(@withdrawl_request), alert: "Invalid previous transaction"
      end

      return unless @withdrawl_request.can_confirm?

      if @withdrawl_request.confirm
        redirect_to admins_coins_path, notice: "Success"
      else
        redirect_to admins_new_withdrawl_request_path, alert: transaction.error_message
      end
    end

    private

    def find_previous_transaction
      @previous_transaction = Transactions::MemberWithdrawl.ordered.for_source(@withdrawl_request.member).last
    end

    def find_withdrawl_request
      @withdrawl_request = WithdrawlRequest.find(params[:id])
    end

    def confirmation_params
      permitted_params.merge(
        last_changed_by: current_member
      )
    end
  end
end
