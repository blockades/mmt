# frozen_string_literal: true

module Members
  class ExchangesController < ApplicationController
    before_action :find_coin, except: [:index]

    def index
    end

    def new
    end

    def create
      transaction = verify_nonce :system_exchange, 15.seconds do
        Transaction::SystemExchange.create(exchange_params)
      end

      if transaction && transaction.persisted?
        redirect_to coins_path, notice: "Success"
      else
        error = transaction ? exchange.errors : "Wait for 15 seconds before proceeding"
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

    def exchange_params
      permitted_params.merge(
        destination_coin_id: @coin.id,
        destination_member_id: current_member.id
      )
    end
  end
end
