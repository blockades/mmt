# frozen_string_literal: true

module Members
  class WithdrawlRequestsController < ApplicationController
    before_action :find_coin, only: [:new, :create]
    before_action :find_withdrawl_request, only: [:cancel]

    def new
    end

    def create
      unless permitted_params[:source_quantity].present?
        redirect_back fallback_location: new_withdrawl_path, notice: 'Specify an amount to withdraw' and return
      end
      command = Command::Transaction::Withdraw.new(withdrawl_params)
      execute command
      head :ok
    rescue Command::ValidationError => error
      head 403
    end

    def cancel
      @withdrawl_request.cancel!(current_member.id)
      head :ok
    end

    private

    def find_withdrawl_request
      @withdrawl_request = WithdrawlRequest.find(params[:id])
    end

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def permitted_params
      params.require(:withdrawl).permit(:source_quantity)
    end

    def withdrawl_params
      permitted_params.merge(
        source_coin_id: @coin.id,
        source_quantity: source_quantity_as_integer,
        member_id: current_member.id,
      ).to_h.symbolize_keys
    end

    def source_quantity_as_integer
      (permitted_params.fetch(:source_quantity).to_d * 10**@coin.subdivision).to_i
    end
  end
end
