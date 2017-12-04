# frozen_string_literal: true

module Admins
  class SystemAllocationsController < AdminsController
    include TransactionHelper

    before_action :find_coin
    before_action :find_previous_transaction, only: [:new, :create]

    def new
    end

    def create
      unless previous_transaction?
        return redirect_back fallback_location: admins_new_coin_allocation_path(@coin.id), alert: "Invalid previous transaction"
      end

      transaction = transaction_commiter(Transactions::SystemAllocation, allocation_params)

      if transaction.persisted?
        redirect_to admins_coins_path, notice: "Allocated #{transaction.destination_quantity/(10**@coin.subdivision)} #{@coin.code}"
      else
        redirect_to admins_new_coin_allocation_path(@coin.id), error: transaction.error_message
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def find_previous_transaction
      @previous_transaction = Transactions::SystemAllocation.ordered.for_destination(current_member).last
    end

    def permitted_params
      params.require(:allocation).permit(
        :destination_id,
        :destination_quantity,
        :destination_rate,
        :previous_transaction_id
      )
    end

    def allocation_params
      permitted_params.merge(
        source_id: @coin.id,
        source_type: Coin,
        source_coin_id: @coin.id,
        destination_type: Member,
        destination_coin_id: @coin.id,
        initiated_by_id: current_member.id
      )
    end
  end
end
