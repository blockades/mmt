class CreateMemberCoinEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :member_coin_events, id: :uuid do |t|
      t.references :coin, type: :uuid, foreign_key: true, index: true
      t.references :member, type: :uuid, foreign_key: true, index: true
      t.references :system_transaction, type: :uuid, foreign_key: true, index: true
      t.integer :liability, limit: 8
      t.decimal :rate

      t.timestamps
    end
  end
end


