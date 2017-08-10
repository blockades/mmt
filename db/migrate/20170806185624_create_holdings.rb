class CreateHoldings < ActiveRecord::Migration[5.0]
  def change
    create_table :holdings do |t|
      t.integer :user_plan_id
      t.integer :coin_id
      t.integer :admin_id

      t.decimal :amount, precision: 10, scale: 2, default: 0.0
      t.decimal :crypto, precision: 20, scale: 15, default: 0.0

      t.timestamps
    end
  end
end
