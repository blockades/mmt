# frozen_string_literal: true

module Members
  class DashboardController < ApplicationController
    def index
      @coins = Coin.all.decorate
    end
  end
end
