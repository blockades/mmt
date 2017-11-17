# frozen_string_literal: true

module Members
  class WithdrawlsController < ApplicationController
    before_action :find_coin, except: [:index]

    def index
    end

    def new
    end

    def create
      unless permitted_params[:source_quantity].present?
        redirect_back fallback_location: new_withdrawl_path, notice: 'Specify an amount to withdraw' and return
      end

      transaction = verify_nonce :member_withdrawl, 60.seconds do
        Transaction::MemberWithdrawl.create(withdrawl_params)
      end

      if transaction && transaction.persisted?
        redirect_to coins_path, notice: "Success"
      else
        error = transaction ? transaction.errors : "Wait 60 seconds before proceeding"
        redirect_to new_withdrawl_path, error: error
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def permitted_params
      params.require(:withdrawl).permit(:source_quantity)
    end

    def withdrawl_params
      permitted_params.merge(
        source_coin_id: @coin.id,
        source_quantity: source_quantity_as_integer,
        destination_member_id: current_member.id,
      ).to_h.symbolize_keys
    end

    def source_quantity_as_integer
      (permitted_params.fetch(:source_quantity).to_d * 10**@coin.subdivision).to_i
    end
  end
end
