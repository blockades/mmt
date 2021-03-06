# frozen_string_literal: true

module Members
  class GiftsController < ApplicationController
    include TransactionHelper

    before_action :find_coin, except: [:index]
    before_action :find_previous_transaction, only: [:new, :create]
    before_action :check_previous_transaction, only: [:create]

    def index; end

    def new; end

    def create
      transaction = transaction_commiter(Transactions::MemberAllocation, gift_params)

      if transaction.persisted?
        redirect_to root_path, notice: "Success"
      else
        redirect_to new_gift_path, alert: transaction.error_message
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def find_previous_transaction
      @previous_transaction = Transactions::MemberAllocation.ordered.for_destination(current_member).last
    end

    def check_previous_transaction
      return if previous_transaction?
      redirect_back fallback_location: new_gift_path,
                    alert: "Invalid previous transaction"
    end

    def permitted_params
      params.require(:gift).permit(
        :destination_quantity,
        :previous_transaction_id,
        :destination_id,
        :destination_rate
      )
    end

    def gift_params
      permitted_params.merge(
        source_id: current_member.id,
        source_type: Member,
        source_coin_id: @coin.id,
        source_rate: permitted_params[:destination_rate],
        destination_type: Member,
        destination_coin_id: @coin.id,
        initiated_by_id: current_member.id
      )
    end
  end
end
