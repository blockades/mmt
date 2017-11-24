# frozen_string_literal: true

module Members
  class ExchangesController < ApplicationController
    before_action :find_coin, except: [:index]
    before_action :find_previous_transaction, only: [:new]

    def index
    end

    def new
    end

    def create
      transaction = verify_nonce :system_exchange, 15.seconds do
        Transaction::MemberExchange.create(exchange_params)
      end

      if transaction.persisted?
        redirect_to coins_path, notice: "Success"
      else
        error = transaction ? transaction.errors : "Wait for 15 seconds before proceeding"
        redirect_to new_exchange_path, error: error
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def find_previous_transaction
      @previous_transaction = Transaction::MemberExchange.order('created_at DESC').find_by(source_id: current_member.id, destination_id: current_member.id)
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
        source_type: "Member",
        destination_id: current_member.id,
        destination_type: "Member",
        destination_coin_id: @coin.id,
        initiated_by_id: current_member.id
      )
    end
  end
end
