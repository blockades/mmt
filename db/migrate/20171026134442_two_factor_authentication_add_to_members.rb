class TwoFactorAuthenticationAddToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :second_factor_attempts_count, :integer, default: 0
    add_column :members, :encrypted_otp_secret_key, :string
    add_column :members, :encrypted_otp_secret_key_iv, :string
    add_column :members, :encrypted_otp_secret_key_salt, :string
    add_column :members, :direct_otp, :string
    add_column :members, :direct_otp_sent_at, :datetime
    add_column :members, :totp_timestamp, :timestamp

    add_column :members, :otp_setup_finalised, :boolean
    add_column :members, :country_code, :string
    add_column :members, :phone_number, :string

    add_index :members, :encrypted_otp_secret_key, unique: true
  end
end
