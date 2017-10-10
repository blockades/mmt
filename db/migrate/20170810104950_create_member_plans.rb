class CreateMemberPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :member_plans do |t|
      t.integer :member_id, index: true
      t.integer :plan_id, index: true
      t.decimal :amount, precision: 10, scale: 2, default: 0.0
      t.string :currency, limit: 50, default: 'United States Dollar'
      t.string :iso_currency, limit: 4, default: 'USD'
      t.string :sale_type, default: 'B'
      t.boolean :iou, default: false

      t.timestamps
    end
  end
end
