class Holding < ApplicationRecord
  belongs_to :coin
  belongs_to :portfolio

  delegate :user, to: :user_plan, :allow_nil => true

  before_create :calculate_crypto_value

  private

  def calculate_crypto_value
    self.crypto = amount / coin.value(user_plan.iso_currency)
  end
end
