# frozen_string_literal: true

module Members
  class CoinsController < ApplicationController
    before_action :find_coin, only: [:show]

    def index
      @member = current_member.decorate
      @crypto = current_member.crypto.with_liability
      @fiat = current_member.fiat.with_liability
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: @coin.as_json(methods: [:btc_rate]) }
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:id]).decorate
    end
  end
end
