class Holding < ApplicationRecord
  belongs_to :user_plan
  belongs_to :coin

  before_create :calculate_crypto_value

  private

  def calculate_crypto_value
    self.crypto = amount / coin.value(user_plan.iso_currency)
  end
end
