class AddHashToTransaction < ActiveRecord::Migration[5.1]
  def self.up
    add_column :system_transactions, :previous_transaction_hash, :string

    transaction do
      Transactions::Base::TYPES.each do |klass|
        tx = "Transactions::#{klass}".constantize.ordered.last
        recurse(tx)
      end
    end
  end

  def self.down
    remove_column :system_transactions, :previous_transaction_hash
  end

  def recurse(tx)
    unless tx.nil? || tx.previous_transaction.nil?
      tx.update_columns(previous_transaction_hash: tx.previous_transaction.as_hash)
      recurse(tx.previous_transaction)
    end
  end
end
