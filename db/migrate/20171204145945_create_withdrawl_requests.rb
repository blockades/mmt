class CreateWithdrawlRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :withdrawl_requests, id: :uuid do |t|
      t.references :member, type: :uuid, foreign_key: true, null: false
      t.references :admin, type: :uuid, foreign_key: { to_table: :members }
      t.references :coin, type: :uuid, foreign_key: true, null: false
      t.references :system_transaction, type: :uuid, foreign_key: true

      t.references :last_touched_by, type: :uuid, foreign_key: { to_table: :members }, null: false
      t.references :processed_by, type: :uuid, foreign_key: { to_table: :members }
      t.references :confirmed_by, type: :uuid, foreign_key: { to_table: :members }
      t.references :completed_by, type: :uuid, foreign_key: { to_table: :members }
      t.references :cancelled_by, type: :uuid, foreign_key: { to_table: :members }

      t.string :state, default: :pending, null: false

      t.integer :quantity, limit: 8, null: false
      t.decimal :rate, null: false

      t.timestamps
    end
  end
end
