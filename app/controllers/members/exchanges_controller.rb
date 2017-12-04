# frozen_string_literal: true

module Members
  class ExchangesController < ApplicationController
    include TransactionHelper

    before_action :find_coin, except: [:index]
    before_action :find_previous_transaction, only: [:new]

    def index
    end

    def new
    end

    def create
      unless previous_transaction?
        return redirect_back fallback_location: new_exchange_path, alert: "Invalid previous transaction"
      end

      transaction = transaction_commiter(Transactions::MemberExchange, exchange_params)

      if transaction.persisted?
        redirect_to coins_path, notice: "Success"
      else
        redirect_to new_exchange_path, alert: transaction.error_message
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def find_previous_transaction
      @previous_transaction = Transactions::MemberExchange.ordered.for_source(current_member).last
    end

    def permitted_params
      params.require(:exchange).permit(
        :destination_rate,
        :destination_quantity,
        :source_coin_id,
        :source_rate,
        :source_quantity,
        :previous_transaction_id
      )
    end

    def exchange_params
      permitted_params.merge(
        source_id: current_member.id,
        source_type: Member,
        destination_id: current_member.id,
        destination_type: Member,
        destination_coin_id: @coin.id,
        initiated_by_id: current_member.id
      )
    end
  end
end
