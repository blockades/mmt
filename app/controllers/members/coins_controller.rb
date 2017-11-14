# frozen_string_literal: true

module Members
  class CoinsController < ApplicationController
    before_action :find_coin, only: [:show]

    def index
      @member = current_member.decorate
      @crypto = Coin.crypto_with_balance(current_member)
      @fiat = Coin.fiat_with_balance(current_member)
      @withdrawls = current_member.outstanding_withdrawl_requests
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: { coin: @coin, btc_rate: @coin.btc_rate } }
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:id]).decorate
    end
  end
end
