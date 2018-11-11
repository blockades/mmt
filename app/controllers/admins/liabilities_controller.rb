# frozen_string_literal: true

module Admins
  class LiabilitiesController < AdminsController
    before_action :coin, only: :show
    before_action :liability, only: :show

    def index
      @liabilities =
        coin
        .liability_events
        .ordered
        .includes(:system_transaction)
    end

    def show; end

    private

    def coin
      @coin ||= Coin.friendly.find(params[:coin_id])
    end

    def liability
      @liability = Events::Liability.find(params[:id])
    end
  end
end
