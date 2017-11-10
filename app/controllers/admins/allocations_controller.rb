# frozen_string_literal: true

# %%NOTE%%
# This is a temporary measure for the sake of the initial admin assigning value to a member
# In the future this will be removed when allocation is done by the system itself on a load event
# by fulfilling outstanding ExchangeOrders

module Admins
  class AllocationsController < AdminsController
    before_action :find_coin

    def new
    end

    def create
      command = Command::Transaction::Allocate.new(allocation_params)
      execute command
      redirect_to admins_coins_path, notice: "Successfully allocated #{quantity_as_integer}"
    rescue Command::ValidationError => error
      redirect_to admins_new_coin_allocation_path(@coin.id), error: error.inspect
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def permitted_params
      params.require(:allocation).permit(:member_id, :destination_quantity, :destination_rate)
    end

    def allocation_params
      permitted_params.merge(
        destination_quantity: quantity_as_integer,
        destination_coin_id: @coin.id,
        admin_id: current_member.id,
      ).to_h.symbolize_keys
    end

    def quantity_as_integer
      (permitted_params.fetch(:destination_quantity).to_d * 10**@coin.subdivision).to_i
    end
  end
end
