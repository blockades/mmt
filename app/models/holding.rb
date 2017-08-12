class Holding < ApplicationRecord
  belongs_to :user_plan
  belongs_to :coin
  belongs_to :admin, class_name: 'User', foreign_key: :admin_id

  delegate :user, to: :user_plan, :allow_nil => true

  before_create :calculate_crypto_value

  private

  def calculate_crypto_value
    self.crypto = amount / coin.value(user_plan.iso_currency)
  end
end
