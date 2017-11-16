class CreateCoinEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :coin_events, id: :uuid do |t|
      t.uuid :coin_id, index: true
      t.uuid :transaction_id, index: true
      t.integer :liability, limit: 8
      t.integer :available, limit: 8

      t.timestamps
    end
  end
end
