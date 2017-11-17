# frozen_string_literal: true

module Admins
  class SystemAllocationsController < AdminsController
    before_action :find_coin

    def new
    end

    def create
      transaction = verify_nonce :member_withdrawl, 60.seconds do
        Transaction::SystemAllocation.create(allocation_params)
      end

      if transaction && transaction.persisted?
        redirect_to admins_coins_path, notice: "Successfully allocated #{quantity_as_integer}"
      else
        error = transaction ? transaction.errors : "Wait 60 seconds before proceeding"
        redirect_to admins_new_coin_allocation_path(@coin.id), error: "Fail"
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def permitted_params
      params.require(:allocation).permit(:destination_member_id, :destination_quantity, :destination_rate)
    end

    def allocation_params
      permitted_params.merge(
        destination_quantity: quantity_as_integer,
        destination_coin_id: @coin.id,
        source_member_id: current_member.id,
      ).to_h.symbolize_keys
    end

    def quantity_as_integer
      (permitted_params.fetch(:destination_quantity).to_d * 10**@coin.subdivision).to_i
    end
  end
end
