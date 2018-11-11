# frozen_string_literal: true

module Admins
  class SystemWithdrawlsController < AdminsController
    include TransactionHelper

    before_action :find_coin
    before_action :find_previous_transaction, only: [:new, :create]
    before_action :check_previous_transaction, only: [:create]

    def new
      @system_withdrawl = Transactions::SystemWithdrawl.new
    end

    def create
      transaction = transaction_commiter(Transactions::SystemWithdrawl, withdrawl_params)

      if transaction.persisted?
        quantity = Utils.to_decimal(transaction.source_quantity, @coin.subdivision)
        redirect_to admins_root_path, notice: "Withdrew #{quantity} #{@coin.code}"
      else
        redirect_to admins_new_withdrawl_path, alert: transaction.error_message
      end
    end

    private

    def find_coin
      @coin = Coin.friendly.find(params[:coin_id]).decorate
    end

    def find_previous_transaction
      @previous_transaction = Transactions::SystemWithdrawl.ordered.for_destination(current_member).last
    end

    def check_previous_transaction
      return if previous_transaction?
      return redirect_back fallback_location: admins_new_withdrawl_path(@coin.id),
                           alert: "Invalid previous transaction"
    end

    def permitted_params
      params.require(:transactions_system_withdrawl).permit(
        :source_quantity,
        :previous_transaction_id,
        comments_attributes: [:body],
        transaction_id_attributes: [:body],
        signatures_attributes: [:member_id]
      )
    end

    def withdrawl_params
      permitted_params.merge(
        destination_id: current_member.id,
        destination_type: Member,
        destination_coin_id: @coin.id,
        source_id: @coin.id,
        source_type: Coin,
        source_coin_id: @coin.id,
        initiated_by_id: current_member.id,
        comments_attributes: comments_attributes,
        transaction_id_attributes: transaction_id_attributes
      )
    end

    def comments_attributes
      return {} unless permitted_params[:comments_attributes]
      permitted_params[:comments_attributes].transform_values do |attributes|
        attributes.merge(
          member_id: current_member.id,
          annotatable_type: Transactions::SystemDeposit,
          type: Annotations::Comment
        )
      end
    end

    def transaction_id_attributes
      return {} unless permitted_params[:transaction_id_attributes]
      permitted_params[:transaction_id_attributes].merge(
        member_id: current_member.id,
        annotatable_type: Transactions::SystemDeposit,
        type: Annotations::TransactionId
      )
    end
  end
end
