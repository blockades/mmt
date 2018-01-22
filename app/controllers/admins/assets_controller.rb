# frozen_string_literal: true

module Admins
  class AssetsController < AdminsController
    def index
      @collection =
        coin
        .asset_events
        .ordered
        .includes(:system_transaction)
    end

    private

    def coin
      @coin ||= Coin.friendly.find(params[:coin_id])
    end
  end
end
