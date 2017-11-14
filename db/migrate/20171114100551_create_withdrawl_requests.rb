class CreateWithdrawlRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :withdrawl_requests, id: :uuid do |t|
      t.string :state, default: :pending
      t.references :member, type: :uuid, foreign_key: true
      t.references :coin, type: :uuid, foreign_key: true
      t.integer :quantity
      t.uuid :transaction_id
      t.uuid :last_changed_by_id
      t.uuid :in_progress_by_id
      t.uuid :confirmed_by_id
      t.uuid :completed_by_id
      t.uuid :cancelled_by_id

      t.timestamps
    end

    add_index :withdrawl_requests, :last_changed_by_id
    add_index :withdrawl_requests, :in_progress_by_id
    add_index :withdrawl_requests, :confirmed_by_id
    add_index :withdrawl_requests, :completed_by_id
    add_index :withdrawl_requests, :cancelled_by_id
  end
end
