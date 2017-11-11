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
      unless permitted_params[:destination_quantity].present?
        redirect_back fallback_location: admins_new_coin_allocation_path(@coin), alert: 'Quantity required' and return
      end
      Domain::Transaction.new(exchange_params).append_to_stream!
    rescue ArgumentError => error
      Rails.logger.error(error)
      redirect_to admins_new_coin_allocation_path(@coin.id), error: error.inspect
    rescue Domain::Transaction::ValidationError => error
      Rails.logger.error(error)
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
