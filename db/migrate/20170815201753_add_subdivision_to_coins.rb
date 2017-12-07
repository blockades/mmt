class AddSubdivisionToCoins < ActiveRecord::Migration[5.0]
  def change
    add_column :coins, :crypto_currency, :boolean, default: true, null: false
    add_column :coins, :subdivision, :integer, default: 8, null: false
    remove_index :coins, :code
    add_index :coins, :code, unique: true
  end
end
