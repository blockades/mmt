class CreateUserPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :user_plans do |t|
      t.integer :user_id
      t.integer :plan_id
      t.decimal :amount, precision: 10, scale: 2, default: 0.0
      t.string :currency, limit: 50, default: 'United States Dollar'
      t.string :iso_currency, limit: 4, default: 'USD'
      t.string :sale_type, default: 'B'
      t.boolean :iou, default: false

      t.timestamps
    end
  end
end
