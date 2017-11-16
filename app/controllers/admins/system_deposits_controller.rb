# frozen_string_literal: true

module Admins
  class SystemDepositsController < AdminsController
    before_action :find_coin

    def new
    end

    def create
      unless permitted_params[:destination_quantity].present?
        redirect_back fallback_location: admins_new_coin_deposit_path(@coin), alert: 'Quantity required' and return
      end
      transaction = Transaction::SystemDeposit.create(deposit_params)
      if transaction.persisted?
        redirect_to admins_coins_path(@coin), notice: 'Success'
      else
        redirect_to admins_new_coin_deposit_path(@coin), alert: 'Fail'
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
        destination_quantity: quantity_as_integer,
        destination_coin_id: @coin.id,
        source_member_id: current_member.id,
      ).to_h.symbolize_keys
    end

    def quantity_as_integer
      (permitted_params.fetch(:destination_quantity).to_d * 10**@coin.subdivision).to_i
    end
  end
end
