class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.integer :recipient_id, index: true
      t.string :notification_type
      t.string :title
      t.text :body
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
