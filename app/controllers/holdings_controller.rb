class HoldingsController < ApplicationController

  def index
    @holdings = Holding.all
  end

end
