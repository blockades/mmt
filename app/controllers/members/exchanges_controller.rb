# frozen_string_literal: true

module Members
  class ExchangesController < ApplicationController
    before_action :find_coin, except: [:index]

    def index
    end

    def new
    end

    def create
      unless (required_params - permitted_params.to_h.symbolize_keys.keys).empty?
        redirect_back fallback_location: new_exchange_path, notice: 'Missing fields' and return
      end
      command = Command::Transaction::Exchange.new(exchange_params)
      execute command
      redirect_to coins_path, notice: "Success"
    rescue Command::ValidationError => error
      redirect_to new_exchange_path, error: error
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def required_params
      [
        :destination_rate, :destination_quantity,
        :source_coin_id, :source_rate, :source_quantity
      ]
    end

    def permitted_params
      params.require(:exchange).permit(*required_params)
    end

    def exchange_params
      permitted_params.merge(
        destination_coin_id: @coin.id,
        destination_quantity: destination_quantity_as_integer,
        source_quantity: source_quantity_as_integer,
        member_id: current_member.id,
      ).to_h.symbolize_keys
    end

    def destination_quantity_as_integer
      (permitted_params.fetch(:destination_quantity).to_d * 10**@coin.subdivision).to_i
    end

    def source_quantity_as_integer
      coin = ::Coin.find(permitted_params[:source_coin_id])
      (permitted_params.fetch(:source_quantity).to_d * 10**coin.subdivision).to_i
    end
  end
end
