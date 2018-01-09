# frozen_string_literal: true

module Members
  class WithdrawlRequestsController < ApplicationController

    before_action :find_coin, except: [:index]
    before_action :find_withdrawl_request, only: [:cancel]

    def index
      @withdrawl_requests = current_member.withdrawl_requests.decorate
    end

    def new
      @withdrawl_request = current_member.withdrawl_requests.build
    end

    def create
      withdrawl_request = WithdrawlRequest.create(withdrawl_request_params)

      if withdrawl_request.persisted?
        redirect_to withdrawl_requests_path, notice: "Withdrawl Request lodged"
      else
        redirect_to new_coin_withdrawl_request_path(@coin), alert: withdrawl_request.error_message
      end
    end

    def cancel
      if @withdrawl_request.cancel!(member: current_member)
        redirect_to withdrawl_requests_path, notice: "Success"
      else
        redirect_to withdrawl_requests_path, alert: "Failed"
      end
    end

    private

    def find_coin
      @coin = params[:coin_id] ? Coin.friendly.find(params[:coin_id]).decorate : nil
    end

    def find_withdrawl_request
      @withdrawl_request = WithdrawlRequest.find(params[:id])
    end

    def permitted_params
      params.require(:withdrawl_request).permit(:quantity, :rate)
    end

    def withdrawl_request_params
      permitted_params.merge(
        member_id: current_member.id,
        coin_id: @coin.id,
        last_changed_by_id: current_member.id
      )
    end
  end
end
