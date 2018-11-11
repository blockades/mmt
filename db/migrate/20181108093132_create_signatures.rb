class CreateSignatures < ActiveRecord::Migration[5.1]
  def change
    create_table :signatures, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.references :member, type: :uuid, foreign_key: true, null: false
      t.references :system_transaction, type: :uuid, foreign_key: true, null: false

      t.timestamps
    end

    add_index :signatures, [:member_id, :system_transaction_id], unique: true
  end
end
