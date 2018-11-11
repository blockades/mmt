# frozen_string_literal: true

class MemberDecorator < Draper::Decorator
  delegate_all

  def coin_liability(coin)
    Utils.to_decimal(liability(coin), coin.subdivision)
  end

  def two_factor_delivery_method
    Member::TWO_FACTOR_DELIVERY_METHODS[otp_delivery_method].downcase
  end

  def full_phone_number
    country_code.present? && phone_number.present? ? I18n.t("member.phone_number.complete", country_code: country_code, phone_number: phone_number) : I18n.t("member.phone_number.missing")
  end
end
