class TrimTables < ActiveRecord::Migration[5.0]
  def self.up
    drop_table :details
    drop_table :user_plans
    drop_table :plans
  end

  def self.down
    create_table :plans do |t|
      t.string :name

      t.timestamps
    end

    create_table :user_plans do |t|
      t.integer :user_id, index: true
      t.integer :plan_id, index: true
      t.decimal :amount, precision: 10, scale: 2, default: 0.0
      t.string :currency, limit: 50, default: 'United States Dollar'
      t.string :iso_currency, limit: 4, default: 'USD'
      t.string :sale_type, default: 'B'
      t.boolean :iou, default: false

      t.timestamps
    end

    create_table :details do |t|
      t.string :type
      t.integer :plan_id, index: true
      t.integer :coin_id, index: true
      t.decimal :proportion, precision: 5, scale: 2, default: 100.00

      t.timestamps
    end

    add_foreign_key "details", "coins", name: "details_coin_id_fk"
    add_foreign_key "details", "plans", name: "details_plan_id_fk"
    add_foreign_key "user_plans", "plans", name: "user_plans_plan_id_fk"
    add_foreign_key "user_plans", "users", name: "user_plans_user_id_fk"
  end
end
