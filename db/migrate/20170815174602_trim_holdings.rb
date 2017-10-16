class TrimHoldings < ActiveRecord::Migration[5.0]
  def change
    remove_column :holdings, :admin_id, :uuid
    remove_column :holdings, :amount, :decimal, precision: 20, scale: 15, default: 0.0
    rename_column :holdings, :rate, :initial_btc_rate
    add_column :holdings, :deposit, :boolean, default: false, null: false
    add_column :holdings, :withdrawal, :boolean, default: false, null: false
  end
end
