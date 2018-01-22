# frozen_string_literal: true

module Members
  class MemberCoinEventsController < MembersController
    def index
      @member_coin_events =
        MemberCoinEvent.where(coin: coin, member: current_member)
        .ordered
        .includes(system_transaction: :initiated_by)
    end

    private

    def coin
      @coin ||= Coin.friendly.find(params[:coin_id])
    end
  end
end
