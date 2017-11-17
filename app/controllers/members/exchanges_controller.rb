# frozen_string_literal: true

module Members
  class ExchangesController < ApplicationController
    before_action :find_coin, except: [:index, :create]

    def index
    end

    def new
    end

    def create
      exchange = verify_nonce :system_exchange, 60.seconds do
        MemberExchangeWithSystem.call(permitted_params: permitted_params.merge(
          destination_coin_id: params[:coin_id],
          destination_member_id: current_member.id
        ))
      end

      if exchange && exchange.success?
        redirect_to coins_path, notice: exchange.message
      else
        error = exchange ? exchange.message : "Wait for 60 seconds before proceeding"
        redirect_to new_exchange_path, error: error
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def permitted_params
      params.require(:exchange).permit(:destination_rate, :destination_quantity, :source_coin_id, :source_rate, :source_quantity)
    end
  end
end
