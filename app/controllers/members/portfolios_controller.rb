# frozen_string_literal: true

module Members
  class PortfoliosController < ApplicationController

    def index
      @portfolios = Portfolio.all
    end

    def new
      @portfolio_id = SecureRandom.uuid
      @coins = Coin.all
      @members = Member.all
    end

    def add_asset
      execute Command::AddAssetToPorfolio.new(asset_params)

      respond_to do |format|
        format.js { flash[:notice] = "Successfully added to asset to your portfolio" }
      end
    end

    private

    def asset_params
      parameters = params.permit(:coin_id, :id)
      { coin_id: parameters[:coin_id], portfolio_id: parameters[:id] }
    end

  end
end
