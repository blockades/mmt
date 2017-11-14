class CreateWithdrawlRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :withdrawl_requests, id: :uuid do |t|
      t.references :member, type: :uuid, foreign_key: true
      t.references :coin, type: :uuid, foreign_key: true
      t.uuid :last_changed_by_id
      t.integer :quantity
      t.uuid :transaction_id
      t.string :state, default: :pending

      t.timestamps
    end

    add_index :withdrawl_requests, :last_changed_by_id
  end
end
