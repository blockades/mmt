# frozen_string_literal: true

module Members
  class CoinsController < ApplicationController
    before_action :find_coin, only: [:show]

    def index
      @coin = Coin.btc.decorate
      @member = current_member.decorate
      @coins = current_member.coins
      @crypto = @coins.crypto
      @fiat = @coins.fiat
    end

    def show
      respond_to do |format|
        format.json { render json: @coin.as_json(methods: [:btc_rate, :member_total_display]) }
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:id]).decorate
    end
  end
end
