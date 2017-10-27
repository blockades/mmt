class TwoFactorRecoveryAddToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :second_factor_recovery_count, :integer, default: 0
    add_column :members, :otp_recovery_codes, :text, array: true
  end
end
