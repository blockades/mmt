# frozen_string_literal: true

module Admins
  class SystemDepositsController < AdminsController
    before_action :find_coin
    before_action :find_previous_transaction, only: [:new]

    def new
    end

    def create
<<<<<<< HEAD
      transaction = verify_nonce :system_deposit, 15.seconds do
=======
      transaction = ActiveRecord::Base.transaction do
>>>>>>> 1ccfe31... Clarify transaction source/destination logic with polymorphism
        Transaction::SystemDeposit.create(deposit_params)
      end

      if transaction.persisted?
        redirect_to admins_coins_path(@coin), notice: 'Success'
      else
        error = transaction ? transaction.errors : "Wait for 15 seconds before proceeding"
        redirect_to admins_new_coin_deposit_path(@coin), alert: error
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def find_previous_transaction
      @previous_transaction = Transaction::SystemDeposit.order('created_at DESC').find_by(source_id: current_member.id, destination_id: @coin.id)
    end

    def permitted_params
      params.require(:deposit).permit(
        :destination_quantity,
        :destination_rate,
        :previous_transaction_id
      )
    end

    def deposit_params
      permitted_params.merge(
        destination_id: @coin.id,
        destination_type: 'Coin',
        destination_coin_id: @coin.id,
        source_id: current_member.id,
        source_type: 'Member',
        source_coin_id: @coin.id,
        initiated_by_id: current_member.id
      )
    end
  end
end
