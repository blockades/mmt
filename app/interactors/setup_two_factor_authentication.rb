# frozen_string_literal: true

class SetupTwoFactorAuthentication
  include Interactor

  def call
    ActiveRecord::Base.transaction do
      member.update otp_delivery_method: otp_delivery_method

      unless setup_by_method.blank?
        setup_by_method.call
        context.message = success_message
      else
        context.fail!(message: 'Invalid delivery method')
        raise ActiveRecord::Rollback
      end
    end
  end

  protected

  def setup_by_method
    {
      app: Proc.new { setup_by_app },
      sms: Proc.new { setup_by_phone }
    }.with_indifferent_access[member.otp_delivery_method]
  end

  def setup_by_app
    context.fail!(message: "Failed to setup two factor authentication. Please try again") unless member.update! app_params
  end

  def setup_by_phone
    if member.update! phone_params
      member.create_direct_otp
      member.send_authentication_code_by_sms!
    else
      context.fail!(message: "Failed to setup two factor authentication. Please try again")
    end
  end

  def success_message
    "Setup authentication by #{Member::TWO_FACTOR_DELIVERY_METHODS[member.otp_delivery_method]}. Please continue to confirm two factor authentication"
  end

  private

  def setup_params
    context.setup_params
  end

  def app_params
    { otp_secret_key: member.generate_totp_secret, otp_recovery_codes: member.generate_otp_recovery_codes }
  end

  def phone_params
    { phone_number: phone_number, country_code: country_code, otp_recovery_codes: member.generate_otp_recovery_codes }
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
