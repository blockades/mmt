# frozen_string_literal: true

module Members
  class SystemTransactionsController < ApplicationController
    before_action :find_transactions, only: [:index]

    def index
      respond_to do |format|
        format.js
      end
    end

    private

    def find_transactions
      @transactions = [
        current_member.source_transactions.where(type: params[:type]),
        current_member.destination_transactions.where(type: params[:type])
      ].flatten
    end
  end
end
