# frozen_string_literal: true

module Members
  class PortfoliosController < ApplicationController
    def show
      @portfolio = current_member.live_portfolio
    end
  end
end
