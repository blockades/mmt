class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.references :source, type: :uuid, polymorphic: true, index: true, null: false
      t.references :destination, type: :uuid, polymorphic: true, index: true, null: false

      t.references :source_coin, type: :uuid, foreign_key: { to_table: :coins }, index: true, null: false
      t.references :destination_coin, type: :uuid, foreign_key: { to_table: :coins }, index: true, null: false

      t.references :previous_transaction, type: :uuid, foreign_key: { to_table: :transactions }, index: true

      t.references :initiated_by, type: :uuid, foreign_key: { to_table: :members }, index: true, null: false
      t.references :authorized_by, type: :uuid, foreign_key: { to_table: :members }, index: true

      t.string :type, null: false

      t.integer :source_quantity, limit: 8
      t.decimal :source_rate

      t.integer :destination_quantity, limit: 8
      t.decimal :destination_rate

      t.timestamps
    end
  end
end
