# frozen_string_literal: true

module Members
  class WithdrawlsController < ApplicationController
    before_action :find_coin, except: [:index]

    def index
    end

    def new
    end

    def create
      # transaction = verify_nonce "member_withdrawl_#{@coin.id}", 60.seconds do
      #   Transaction::MemberWithdrawl.create(withdrawl_params)
      # end
      transaction = Transaction::MemberWithdrawl.create(withdrawl_params)

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
        destination_member_id: current_member.id
      )
    end
  end
end
