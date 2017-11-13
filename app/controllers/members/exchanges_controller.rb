# frozen_string_literal: true

module Members
  class ExchangesController < ApplicationController
    before_action :find_coin, except: [:index, :create]

    def index
    end

    def new
    end

    def create
      if exchange.success?
        redirect_to coins_path, notice: exchange.message
      else
        redirect_to new_exchange_path, error: exchange.message
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def permitted_params
      params.require(:exchange).permit(:destination_rate, :destination_quantity, :source_coin_id, :source_rate, :source_quantity)
    end

    def exchange
      @exchange ||= ExchangeCoins.call(permitted_params: permitted_params.merge(
        destination_coin_id: params[:coin_id],
        member_id: current_member.id
      ))
    end
  end
end
