class CreateSystemTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :system_transactions, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.references :source, type: :uuid, polymorphic: true, index: { name: "transactions_on_source" }, null: false
      t.references :destination, type: :uuid, polymorphic: true, index: { name: "transactions_on_destination" }, null: false

      t.references :source_coin, type: :uuid, foreign_key: { to_table: :coins }, index: true, null: false
      t.references :destination_coin, type: :uuid, foreign_key: { to_table: :coins }, index: true, null: false

      t.references :previous_transaction, type: :uuid, foreign_key: { to_table: :system_transactions }, index: true

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
