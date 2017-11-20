class CreateCoinEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :coin_events, id: :uuid do |t|
      t.references :coin, type: :uuid, foreign_key: true, index: true
      t.references :transaction, type: :uuid, foreign_key: true, index: true
      t.integer :liability, limit: 8
      t.integer :available, limit: 8

      t.timestamps
    end
  end
end
