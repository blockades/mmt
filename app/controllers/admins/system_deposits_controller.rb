# frozen_string_literal: true

module Admins
  class SystemDepositsController < AdminsController
    before_action :find_coin

    def new
    end

    def create
      transaction = verify_nonce :system_deposit, 15.seconds do
        Transaction::SystemDeposit.create(deposit_params)
      end

      if transaction && transaction.persisted?
        redirect_to admins_coins_path(@coin), notice: 'Success'
      else
        error = transaction ? transaction.errors : "Wait for 15 seconds before proceeding"
        redirect_to admins_new_coin_deposit_path(@coin), alert: error
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def permitted_params
      params.require(:deposit).permit(:destination_quantity, :destination_rate)
    end

    def deposit_params
      permitted_params.merge!(
        destination_coin_id: @coin.id,
        source_member_id: current_member.id,
      )
    end
  end
end
