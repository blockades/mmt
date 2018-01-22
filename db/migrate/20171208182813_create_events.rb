class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events, id: :uuid do |t|
      t.string :type, null: false
      t.references :coin, type: :uuid, foreign_key: true, index: true, null: false
      t.references :system_transaction, type: :uuid, foreign_key: true, index: true, null: false
      t.references :member, type: :uuid, foreign_key: true, index: true, null: false
      t.integer :entry, limit: 8, null: false
      t.decimal :rate

      t.timestamps
    end
  end
end
