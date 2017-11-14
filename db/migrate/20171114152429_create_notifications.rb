class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.uuid :recipient_id
      t.string :notification_type
      t.string :title
      t.string :body
      t.boolean :read, default: false

      t.timestamps
    end
    add_index :notifications, :recipient_id
  end
end
