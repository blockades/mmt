# frozen_string_literal: true

module Admins
  class SystemWithdrawlsController < AdminsController
    include TransactionHelper

    before_action :find_coin
    before_action :find_previous_transaction, only: [:new]
    before_action :check_previous_transaction, only: [:create]

    def new; end

    def create
      transaction = transaction_commiter(Transactions::SystemWithdrawl, withdrawl_params)

      if transaction.persisted?
        quantity = Utils.to_decimal(transaction.source_quantity, @coin.subdivision)
        redirect_to admins_coins_path, notice: "Withdrew #{quantity} #{@coin.code}"
      else
        redirect_to new_admins_withdrawl_path, alert: transaction.error_message
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def find_previous_transaction
      @previous_transaction = Transactions::SystemWithdrawl.ordered.for_destination(current_member).last
    end

    def check_previous_transaction
      return if previous_transaction?
      return redirect_back fallback_location: admins_new_withdrawl_path(@coin.id),
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
        destination_id: current_member.id,
        destination_type: Member,
        destination_coin_id: @coin.id,
        source_id: @coin.id,
        source_type: Coin,
        source_coin_id: @coin.id,
        initiated_by_id: current_member.id
      )
    end
  end
end
