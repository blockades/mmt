class CreateMemberCoinEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :member_coin_events, id: :uuid do |t|
      t.references :coin, type: :uuid, foreign_key: true, index: true
      t.references :member, type: :uuid, foreign_key: true, index: true
      t.references :transaction, type: :uuid, foreign_key: true, index: true
      # %%TODO%% Move admin_liability into a fresh table admin_coin_events
      # t.integer :admin_liability, limit: 8
      t.integer :liability, limit: 8
      t.decimal :rate

      t.timestamps
    end
  end
end


