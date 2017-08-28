# frozen_string_literal: true

module Admin
  class PortfoliosController < ApplicationController
    def index
      @portfolios = Portfolio.live.all.includes(:user)
    end

    def show
      @portfolio = Portfolio.find(params[:id])

      respond_to do |format|
        format.json
      end
    end

    def create
      portfolio = Portfolio.new permitted_params
      if previous_portfolio && portfolio.valid? && previous_portfolio.update(next_portfolio: portfolio)
        flash[:success] = "Portfolio created"
        redirect_to action: :index
      else
        flash[:error] = "Portfolio failed to be created"
        render :new
      end
    end

    def new
      @portfolio = Portfolio.new
    end

    private

    def previous_portfolio
      Portfolio.live.find(params[:portfolio][:previous_portfolio_id])
    end

    def permitted_params
      params.require(:portfolio)
            .permit(:user_id, holdings_attributes: [:coin_id, :initial_btc_rate, :deposit, :withdrawal, :quantity])
    end
  end
end
