# frozen_string_literal: true

module Admins
  class DepositsController < AdminsController
    before_action :find_coin

    def new
    end

    def create
      unless permitted_params[:destination_quantity].present?
        redirect_back fallback_location: admins_new_coin_deposit_path(@coin), alert: 'Quantity required' and return
      end
      command = Command::Transaction::Deposit.new(deposit_params)
      execute command
      redirect_to admins_coins_path(@coin), notice: 'Success'
    rescue Command::ValidationError => error
      Rails.logger.error(error)
      redirect_to admins_new_coin_deposit_path(@coin), alert: 'Fail'
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
        admin_id: current_member.id,
      ).to_h.symbolize_keys
    end

    def quantity_as_integer
      (permitted_params.fetch(:destination_quantity).to_d * 10**@coin.subdivision).to_i
    end
  end
end
