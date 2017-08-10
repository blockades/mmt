class CreateCoins < ActiveRecord::Migration[5.0]
  def change
    create_table :coins do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
