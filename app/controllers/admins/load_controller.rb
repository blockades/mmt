# frozen_string_literal: true

module Admins
  class LoadController < AdminController
    before_action :find_coin

    def new
    end

    def create
      command = Command::Transaction::Load.new(load_params)
      execute command
      redirect_to admins_coin_path(@coin), notice: 'Success'
    rescue Command::ValidationError => error
      Rails.logger.error(error)
      redirect_to admins_new_load_coin_path(@coin), alert: 'Fail'
    end

    private

    def find_coin
      @coin = Coin.find params[:coin_id]
    end

    def permitted_params
      params.require(:load).permit(:destination_quantity, :destination_rate)
    end

    def load_params
      permitted_params.merge!(
        destination_quantity: permitted_params.try(:destination_quantity).try(:*, 10**@coin.subdivision),
        destination_coin_id: @coin.id
      )
    end

  end
end
