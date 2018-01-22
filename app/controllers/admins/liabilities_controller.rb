# frozen_string_literal: true

module Admins
  class LiabilitiesController < AdminsController
    def index
      @liabilities =
        coin
        .liability_events
        .ordered
        .includes(:system_transaction)
    end

    private

    def coin
      @coin ||= Coin.friendly.find(params[:coin_id])
    end
  end
end
