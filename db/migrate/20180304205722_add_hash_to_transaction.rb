class AddHashToTransaction < ActiveRecord::Migration[5.1]
  def self.up
    add_column :system_transactions, :previous_transaction_hash, :string

    transaction do
      Transactions::Base::TYPES.each do |klass|
        "Transactions::#{klass}".constantize.ordered.each do |tx|
          recurse(tx)
        end
      end
    end
  end

  def self.down
    remove_column :system_transactions, :previous_transaction_hash
  end

  def recurse(tx)
    return if tx.previous_transaction.nil? || tx.previous_transaction_hash.present?
    tx.update_columns previous_transaction_hash: tx.previous_transaction.as_hash
    recurse(tx.previous_transaction)
  end
end
