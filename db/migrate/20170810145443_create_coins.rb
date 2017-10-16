class CreateCoins < ActiveRecord::Migration[5.0]
  def change
    create_table :coins, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :name
      t.string :code, index: true

      t.timestamps
    end
  end
end
