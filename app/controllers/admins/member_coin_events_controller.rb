# frozen_string_literal: true

module Admins
  class MemberCoinEventsController < AdminsController
    def index
      @member_coin_events =
        coin
        .member_coin_events
        .ordered
        .includes(system_transaction: :initiated_by)
    end

    private

    def coin
      @coin ||= Coin.friendly.find(params[:coin_id])
    end
  end
end
