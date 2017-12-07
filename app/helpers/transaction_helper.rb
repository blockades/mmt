# frozen_string_literal: true

module TransactionHelper
  def previous_transaction?
    @previous_transaction.blank? ? true : (@previous_transaction.id == permitted_params[:previous_transaction_id])
  end

  def transaction_commiter(klass, transaction_params)
    current_member.with_lock do
      klass.create(transaction_params)
    end
  end
end
