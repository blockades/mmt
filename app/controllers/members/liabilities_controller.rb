# frozen_string_literal: true

module Members
  class LiabilitiesController < MembersController
    def index
      @liabilities =
        current_member
        .liability_events
        .where(coin: coin)
        .ordered
        .includes(:system_transaction)
    end

    private

    def coin
      @coin ||= Coin.friendly.find(params[:coin_id])
    end
  end
end
