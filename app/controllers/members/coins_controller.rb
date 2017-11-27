# frozen_string_literal: true

module Members
  class CoinsController < ApplicationController
    before_action :find_coin, only: [:show]

    def index
      @member = current_member.decorate
      @crypto = current_member.crypto
      @fiat = current_member.fiat
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: { coin: @coin, btc_rate: @coin.btc_rate, base_subdivision: @coin.subdivision } }
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:id]).decorate
    end
  end
end
