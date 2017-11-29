# frozen_string_literal: true

module Admins
  class SystemAllocationsController < AdminsController
    before_action :find_coin
    before_action :find_previous_transaction, only: [:new]

    def new
    end

    def create
      transaction = ActiveRecord::Base.transaction do
        Transaction::SystemAllocation.create(allocation_params)
      end

      if transaction.persisted?
        redirect_to admins_coins_path, notice: "Successfully allocated #{transaction.destination_quantity/(10**@coin.subdivision)}"
      else
        error = transaction ? transaction.errors : "Wait 15 seconds before proceeding"
        redirect_to admins_new_coin_allocation_path(@coin.id), error: "Fail"
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def find_previous_transaction
      @previous_transaction = Transaction::SystemAllocation.order('created_at DESC').find_by(source_id: @coin.id)
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
        source_type: 'Coin',
        source_coin_id: @coin.id,
        destination_type: 'Member',
        destination_coin_id: @coin.id,
        initiated_by_id: current_member.id
      )
    end
  end
end
