# frozen_string_literal: true

class HoldingsController < ApplicationController
  def index
    @holdings = Holding.all
  end
end
