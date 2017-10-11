# frozen_string_literal: true

module Members
  class HoldingsController < ApplicationController
    def index
      @holdings = Holding.all
    end
  end
end
