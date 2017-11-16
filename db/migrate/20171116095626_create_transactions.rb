class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :type

      t.string :source_coin_id
      t.string :source_rate
      t.string :source_quantity
      t.string :source_member_id

      t.string :destination_coin_id
      t.string :destination_member_id
      t.string :destination_quantity
      t.string :destination_rate

      t.timestamps
    end
  end
end
