class AddKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key "details", "coins", name: "details_coin_id_fk"
    add_foreign_key "details", "plans", name: "details_plan_id_fk"
    add_foreign_key "holdings", "members", column: "admin_id", name: "holdings_admin_id_fk"
    add_foreign_key "holdings", "coins", name: "holdings_coin_id_fk"
    add_foreign_key "holdings", "member_plans", name: "holdings_member_plan_id_fk"
    add_foreign_key "member_plans", "plans", name: "member_plans_plan_id_fk"
    add_foreign_key "member_plans", "members", name: "member_plans_member_id_fk"
  end
end
