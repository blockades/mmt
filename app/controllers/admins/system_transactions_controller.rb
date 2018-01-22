# frozen_string_literal: true

module Admins
  class SystemTransactionsController < AdminsController
    before_action :find_transactions, only: [:index]

    def index
      respond_to do |format|
        format.js
      end
    end

    private

    def find_transactions
      @transactions = SystemTransaction.where(type: params[:type])
    end
  end
end
