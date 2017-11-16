class CreateMemberCoinEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :member_coin_events, id: :uuid do |t|
      t.uuid :coin_id, index: true
      t.uuid :member_id, index: true
      t.uuid :transaction_id, index: true
      t.integer :available, limit: 8
      t.decimal :rate

      t.timestamps
    end
  end
end
