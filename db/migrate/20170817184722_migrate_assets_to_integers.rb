class MigrateAssetsToIntegers < ActiveRecord::Migration[5.0]
  def change
    remove_column :assets, :crypto, :decimal
    add_column :assets, :quantity, :integer, null: false
    change_column_null :assets, :coin_id, false
    change_column_null :assets, :initial_btc_rate, false
    change_column_null :assets, :portfolio_id, false
  end
end
