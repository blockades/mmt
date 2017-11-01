# frozen_string_literal: true

class SetupTwoFactorAuthentication
  include Interactor

  def call
    store_delivery_method!
    member.authenticated_by_phone? ? setup_two_factor_by_phone! : setup_two_factor_by_app!
    generate_recovery_codes!
    if member.save!
      context.message = "Setup authentication by #{otp_delivery_method}. Please continue to confirm two factor authentication"
    else
      context.fail!(message: "Failed to setup two factor authentication. Please try again")
    end
  end

  private

  def store_delivery_method!
    member.otp_delivery_method = otp_delivery_method
  end

  def setup_two_factor_by_phone!
    member.phone_number = phone_number unless phone_number.blank?
    member.country_code = country_code unless country_code.blank?
    member.send_new_direct_otp_code_sms! unless member.phone_number.blank?
  end

  def setup_two_factor_by_app!
    member.otp_secret_key = member.generate_totp_secret
  end

  def generate_recovery_codes!
    member.otp_recovery_codes = member.generate_otp_recovery_codes
  end

  def setup_params
    context.setup_params
  end

  def member
    context.member
  end

  def otp_delivery_method
    setup_params[:otp_delivery_method]
  end

  def phone_number
    setup_params[:phone_number]
  end

  def country_code
    setup_params[:country_code]
  end
end
