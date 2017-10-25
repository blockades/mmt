class DeviseAuthyAddToMembers < ActiveRecord::Migration[5.0]
  def self.up
    change_table :members do |t|
      t.string    :authy_id
      t.datetime  :last_sign_in_with_authy
      t.boolean   :authy_enabled, default: false
    end

    add_index :members, :authy_id
  end

  def self.down
    change_table :members do |t|
      t.remove :authy_id, :last_sign_in_with_authy, :authy_enabled
    end
  end
end

