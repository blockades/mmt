class MigrateHoldingsToIntegers < ActiveRecord::Migration[5.0]
  def change
    remove_column :holdings, :crypto, :decimal
    add_column :holdings, :quantity, :integer, null: false
    change_column_null :holdings, :coin_id, false
    change_column_null :holdings, :initial_btc_rate, false
    change_column_null :holdings, :portfolio_id, false
  end
end
