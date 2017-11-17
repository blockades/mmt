class AddTwoFactorDeliveryMethodToMember < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :otp_delivery_method, :string
  end
end
