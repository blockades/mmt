# frozen_string_literal: true

module Members
  class DepositsController < ApplicationController
    include TransactionHelper

    before_action :find_coin, except: [:index]
    before_action :find_previous_transaction, only: [:new, :create]

    def index; end

    def new; end

    def create
      unless previous_transaction?
        return redirect_back fallback_location: new_deposit_path, alert: "Invalid previous transaction"
      end

      transaction = transaction_commiter(Transactions::MemberDeposit, deposit_params)

      if transaction.persisted?
        redirect_to coins_path, notice: "Success"
      else
        redirect_to new_deposit_path, alert: transaction.error_message
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def find_previous_transaction
      @previous_transaction = Transactions::MemberDeposit.ordered.for_destination(current_member).last
    end

    def permitted_params
      params.require(:deposit).permit(
        :destination_quantity,
        :previous_transaction_id
      )
    end

    def deposit_params
      permitted_params.merge(
        source_id: @coin.id,
        source_type: Coin,
        source_coin_id: @coin.id,
        destination_id: current_member.id,
        destination_type: Member,
        destination_coin_id: @coin.id,
        initiated_by_id: current_member.id
      )
    end
  end
end
