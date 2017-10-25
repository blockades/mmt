class TwoFactorAuthenticationAddToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :second_factor_attempts_count, :integer, default: 0
    add_column :members, :encrypted_otp_secret_key, :string
    add_column :members, :encrypted_otp_secret_key_iv, :string
    add_column :members, :encrypted_otp_secret_key_salt, :string
    add_column :members, :direct_otp, :string
    add_column :members, :direct_otp_sent_at, :datetime
    add_column :members, :totp_timestamp, :timestamp
    add_column :members, :two_factor_enabled, :boolean, default: false
    add_column :members, :unconfirmed_two_factor, :boolean, default: false
    add_column :members, :phone_number, :string

    add_index :members, :encrypted_otp_secret_key, unique: true
  end
end
