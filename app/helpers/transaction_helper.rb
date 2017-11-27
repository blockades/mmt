# frozen_string_literal: true

module TransactionHelper
  def previous_transaction?
    @previous_transaction.blank? ? true : (@previous_transaction.id == permitted_params[:previous_transaction_id])
  end
end
