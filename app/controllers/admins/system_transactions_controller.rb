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
      arel_table = Transactions::Base.arel_table
      @transactions = Transactions::Base.all
      @transactions = @transactions.where(arel_table[:type].eq(permitted_params[:type])) unless permitted_params[:type].blank?
      @transactions = @transactions.where(arel_table[:source_id].eq(permitted_params[:member_id])
                                   .or(arel_table[:destination_id].eq(permitted_params[:member_id]))) unless permitted_params[:member_id].blank?
      @transactions.includes(
        :previous_transaction,
        :source_coin,
        :destination_coin,
        :initiated_by,
        :authorized_by
      ).references(:system_transactions, :coin, :member)
    end

    def permitted_params
      params.require(:system_transactions).permit(:member_id, :type)
    end
  end
end
