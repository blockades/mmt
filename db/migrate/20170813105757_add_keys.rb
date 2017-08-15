class AddKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key "details", "coins", name: "details_coin_id_fk"
    add_foreign_key "details", "plans", name: "details_plan_id_fk"
    add_foreign_key "holdings", "users", column: "admin_id", name: "holdings_admin_id_fk"
    add_foreign_key "holdings", "coins", name: "holdings_coin_id_fk"
    add_foreign_key "holdings", "user_plans", name: "holdings_user_plan_id_fk"
    add_foreign_key "user_plans", "plans", name: "user_plans_plan_id_fk"
    add_foreign_key "user_plans", "users", name: "user_plans_user_id_fk"
  end
end
