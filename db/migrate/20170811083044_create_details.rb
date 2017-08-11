class CreateDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :details do |t|
      t.string :type
      t.integer :plan_id
      t.integer :coin_id
      t.decimal :rate, precision: 5, scale: 2, default: 100.00

      t.timestamps
    end
  end
end
