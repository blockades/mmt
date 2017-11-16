# frozen_string_literal: true

class MemberDecorator < Draper::Decorator
  delegate_all

  def coin_balance(coin)
    balance(coin.id).to_d / 10**coin.subdivision
  end

  def two_factor_delivery_method
    Member::TWO_FACTOR_DELIVERY_METHODS[otp_delivery_method].downcase
  end
end
