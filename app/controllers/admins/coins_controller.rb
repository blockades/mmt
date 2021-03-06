# frozen_string_literal: true

module Admins
  class CoinsController < AdminsController
    before_action :find_coin, only: [:edit, :update]

    def index
      @coins = Coin.all.decorate
    end

    def edit; end

    def show
      @coin = Coin.includes(
        asset_events: :system_transaction
      ).friendly.find(params[:id])

      respond_to do |format|
        format.html
        format.json { render json: @coin.as_json(methods: [:btc_rate, :system_total_display]) }
      end
    end

    def update
      if @coin.update permitted_params
        redirect_to :index, notice: "Coin updated"
      else
        flash[:alert] = "Coin failed to update"
        render :new
      end
    end

    private

    def find_coin
      @coin ||= Coin.friendly.find(params[:id]).decorate
    end

    def permitted_params
      params.require(:coin).permit(:name)
    end
  end
end
