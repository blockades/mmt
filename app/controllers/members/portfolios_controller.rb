# frozen_string_literal: true

module Members
  class PortfoliosController < ApplicationController

    def index
      @portfolios = Portfolio.all
    end

    def new
      @portfolio = Portfolio.new(id: SecureRandom.uuid)
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
      execute Command::FinalisePortfolio.new(portfolio_params.merge(member_id: current_member.id))

      redirect_to portfolios_path, notice: "Portfolio successfully created"
    end

    def show
      @portfolio = Portfolio.find params[:id]
      @stream = "Domain::Portfolio$#{@portfolio.id}"
      @events = Rails.application.config.event_store.read_events_backward(@stream)
    end

    private

    def asset_params
      params.require(:asset).permit(:coin_id).merge(
        portfolio_id: params[:id],
        member_id: current_member.id
      )
    end

    def portfolio_params
      params.require(:portfolio).permit(:portfolio_id)
    end

  end
end
