# frozen_string_literal: true

module Members
  class WithdrawlsController < ApplicationController
    before_action :find_coin, except: [:index]
    before_action :find_previous_transaction, only: [:new]

    def index
    end

    def new
    end

    def create
      transaction = ActiveRecord::Base.transaction do
        Transaction::MemberWithdrawl.create(withdrawl_params)
      end

      if transaction.persisted?
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

    def find_previous_transaction
      @previous_transaction = Transaction::MemberWithdrawl.order('created_at DESC').find_by(source_id: current_member.id)
    end

    def permitted_params
      params.require(:withdrawl).permit(:source_quantity, :previous_transaction_id)
    end

    def withdrawl_params
      permitted_params.merge(
        source_id: current_member.id,
        source_type: 'Member',
        source_coin_id: @coin.id,
        destination_id: @coin.id,
        destination_type: 'Coin',
        destination_coin_id: @coin.id,
        initiated_by_id: current_member.id
      )
    end
  end
end
