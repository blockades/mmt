# frozen_string_literal: true

module Admins
  class PortfoliosController < AdminsController
    before_action :find_portfolio, only: [:show]

    def index
      @portfolios = Portfolio.live.all.includes(:member)
    end

    def show
      respond_to do |format|
        format.json
      end
    end

    def create
      portfolio = Portfolio.new portfolio_params
      if (previous_portfolio && portfolio.valid? && previous_portfolio.update(next_portfolio: portfolio)) ||
          portfolio.save
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

    def find_portfolio
      @portfolio = Portfolio.find(params[:id])
    end

    def previous_portfolio
      Portfolio.live.find_by(id: params[:portfolio][:previous_portfolio_id])
    end

    def portfolio_params
      params.require(:portfolio).permit(
        :member_id,
        holdings_attributes: [:coin_id, :initial_btc_rate, :deposit, :withdrawal, :quantity]
      )
    end
  end
end
