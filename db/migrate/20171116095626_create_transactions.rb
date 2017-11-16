class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :type

      t.uuid :source_coin_id, index: true
      t.uuid :source_member_id, index: true
      t.integer :source_quantity, limit: 8
      t.decimal :source_rate

      t.uuid :destination_coin_id, index: true
      t.uuid :destination_member_id, index: true
      t.integer :destination_quantity, limit: 8
      t.decimal :destination_rate

      t.timestamps
    end
  end
end
