class AddUsernameToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :username, :string
    add_index :members, :username, unique: true
  end
end
