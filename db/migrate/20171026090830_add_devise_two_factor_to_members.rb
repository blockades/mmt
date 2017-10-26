class AddDeviseTwoFactorToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :encrypted_otp_secret, :string
    add_column :members, :encrypted_otp_secret_iv, :string
    add_column :members, :encrypted_otp_secret_salt, :string
    add_column :members, :consumed_timestep, :integer
    add_column :members, :otp_required_for_login, :boolean
  end
end
