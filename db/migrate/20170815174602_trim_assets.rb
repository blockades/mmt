class TrimAssets < ActiveRecord::Migration[5.0]
  def change
    remove_column :assets, :admin_id, :uuid
    remove_column :assets, :amount, :decimal, precision: 20, scale: 15, default: 0.0
    rename_column :assets, :rate, :initial_btc_rate
    add_column :assets, :deposit, :boolean, default: false, null: false
    add_column :assets, :withdrawal, :boolean, default: false, null: false
  end
end
