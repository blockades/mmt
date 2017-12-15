# frozen_string_literal: true

class MemberDecorator < Draper::Decorator
  delegate_all

  def read_liability(coin)
    Utils.to_decimal(liability(coin), coin.subdivision)
  end

  def read_outstanding_withdrawl_liability(coin)
    Utils.to_decimal(outstanding_withdrawl_liability(coin), coin.subdivision)
  end

  def read_available(coin)
    Utils.to_decimal(available_liability(coin), coin.subdivision)
  end

  def two_factor_delivery_method
    Member::TWO_FACTOR_DELIVERY_METHODS[otp_delivery_method].downcase
  end
end
