# frozen_string_literal: true

module Admins
  class CoinsController < AdminsController
    before_action :find_coin, only: [:edit, :update]

    def index
      @coins = Coin.all
    end

    def edit
    end

    def update
      if @coin.update coin_params
        flash[:success] = "Coin created"
        redirect_to action: :index
      else
        flash[:error] = "Coin failed to be created"
        render :new
      end
    end

    private

    def find_coin
      @coin ||= Coin.friendly.find params[:id]
    end

    def coin_params
      params.require(:coin).permit(:name, :code, :central_reserve_in_sub_units)
    end
  end
end
