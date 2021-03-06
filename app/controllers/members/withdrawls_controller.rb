# frozen_string_literal: true

module Members
  class WithdrawlsController < ApplicationController
    include TransactionHelper

    before_action :find_coin, except: [:index]
    before_action :find_previous_transaction, only: [:new, :create]
    before_action :check_previous_transaction, only: [:create]

    def index
    end

    def new
    end

    def create
      transaction = transaction_commiter(Transactions::MemberWithdrawl, withdrawl_params)

      if transaction.persisted?
        redirect_to root_path, notice: "Success"
      else
        redirect_to new_withdrawl_path, alert: transaction.error_message
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def find_previous_transaction
      @previous_transaction = Transactions::MemberWithdrawl.ordered.for_source(current_member).last
    end

    def check_previous_transaction
      return if previous_transaction?
      redirect_back fallback_location: new_withdrawl_path,
                    alert: "Invalid previous transaction"
    end

    def permitted_params
      params.require(:withdrawl).permit(
        :source_quantity,
        :previous_transaction_id
      )
    end

    def withdrawl_params
      permitted_params.merge(
        source_id: current_member.id,
        source_type: Member,
        source_coin_id: @coin.id,
        destination_id: @coin.id,
        destination_type: Coin,
        destination_coin_id: @coin.id,
        initiated_by_id: current_member.id
      )
    end
  end
end
