# frozen_string_literal: true

module Admins
  class CoinEventsController < AdminsController
    def index
      @coin_events =
        coin
        .coin_events
        .ordered
        .includes(system_transaction: :initiated_by)
    end

    private

    def coin
      @coin ||= Coin.friendly.find(params[:coin_id])
    end
  end
end
