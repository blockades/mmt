# frozen_string_literal: true

class AuthenticateTwoFactor
  include Interactor

  def call
    if member.two_factor_enabled?
      check_for_authentication_code
      authenticate_by_two_factor
      context.message = "Succesfully authenticated"
    else
      context.message = "Two factor not enabled"
    end
  end

  protected

  def check_for_authentication_code
    context.fail!(message: "Two factor authentication required. Please enter a code") unless authentication_code.present?
  end

  def authenticate_by_two_factor
    context.fail!(message: "Two factor authentication failed") unless member.authenticate_otp(authentication_code)
  end

  private

  def member
    context.member
  end

  def authentication_code
    context.password_params[:authentication_code]
  end
end
