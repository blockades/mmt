# frozen_string_literal: true

module Admins
  class AssetsController < AdminsController
    before_action :coin, only: :show
    before_action :asset, only: :show

    def index
      @collection =
        coin
        .asset_events
        .ordered
        .includes(:system_transaction)
    end

    def show; end

    private

    def coin
      @coin ||= Coin.friendly.find(params[:coin_id])
    end

    def asset
      @asset ||= Events::Asset.find(params[:id])
    end
  end
end
