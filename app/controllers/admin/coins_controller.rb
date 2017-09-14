# frozen_string_literal: true

module Admin
  class CoinsController < ApplicationController
    def index
      @coins = Coin.all
    end

    def edit
      coin
    end

    def update
      if coin.save
        flash[:success] = "Coin created"
        redirect_to action: :index
      else
        flash[:error] = "Coin failed to be created"
        render :new
      end
    end

    private

    def coin
      @coin ||= Coin.find params[:id]
    end
  end
end
