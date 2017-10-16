class CreateHoldings < ActiveRecord::Migration[5.0]
  def change
    create_table :holdings, id: :uuid do |t|
      t.uuid :coin_id, index: true, foreign_key: true
      t.uuid :admin_id, index: true, foreign_key: true

      t.decimal :amount, precision: 10, scale: 2, default: 0.0
      t.decimal :crypto, precision: 20, scale: 15, default: 0.0
      t.decimal :rate, precision: 10, scale: 8, default: 0.0

      t.timestamps
    end
  end
end
