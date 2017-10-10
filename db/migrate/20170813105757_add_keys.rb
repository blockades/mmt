class AddKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key "holdings", "members", column: "admin_id", name: "holdings_admin_id_fk"
    add_foreign_key "holdings", "coins", name: "holdings_coin_id_fk"
  end
end
