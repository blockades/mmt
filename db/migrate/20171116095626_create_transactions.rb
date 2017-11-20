class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :type

      t.references :source_member, type: :uuid, foreign_key: { to_table: :members }
      t.references :source_coin, type: :uuid, foreign_key: { to_table: :coins }
      t.integer :source_quantity, limit: 8
      t.decimal :source_rate

      t.references :destination_member, type: :uuid, foreign_key: { to_table: :members }
      t.references :destination_coin, type: :uuid, foreign_key: { to_table: :coins }
      t.integer :destination_quantity, limit: 8
      t.decimal :destination_rate

      t.timestamps
    end
  end
end
