# frozen_string_literal: true

module Members
  class PortfoliosController < ApplicationController

    def index
      @portfolios = Portfolio.all
    end

    def new
      @portfolio = Portfolio.new(uid: SecureRandom.uuid)
      @coins = Coin.all
      @members = Member.all
    end

    def add_asset
      execute Command::AddAssetToPortfolio.new(asset_params)

      respond_to do |format|
        format.js { flash[:notice] = "Successfully added to asset to your portfolio" }
      end
    end

    def create
      command = Command::FinalisePortfolio.new(portfolio_id: portfolio.uid, member_id: portfolio.member_id)
      execute command

      redirect_to portfolios_path, notice: "Portfolio successfully created"
    end

    def show
      @portfolio = Portfolio.find_by_uid(params[:uid])
      @stream = "Domain::Portfolio$#{@portfolio.uid}"
      @events = Rails.application.config.event_store.read_events_backward(@stream)
    end

    private

    def asset_params
      parameters = params.permit(:coin_id, :uid)
      { coin_id: parameters[:coin_id], portfolio_id: parameters[:uid] }
    end

    def portfolio_params
      params.require(:portfolio).permit(:id, :uid)
    end

  end
end
