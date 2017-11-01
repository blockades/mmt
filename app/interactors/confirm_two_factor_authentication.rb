# frozen_string_literal: true

class ConfirmTwoFactorAuthentication
  include Interactor

  def call
    if member.authenticate_otp(authentication_code)
      if member.update!(two_factor_enabled: true)
        context.message = "You have enabled two factor authenitcation"
      else
        context.fail!(message: "Failed to enable two factor authentication")
      end
    else
      current_member.update(two_factor_enabled: false, otp_secret_key: nil, otp_delivery_method: nil)
      context.fail!(message: "Authentication code mismatch, please try again")
    end
  end

  private

  def authentication_code
    context.authentication_code
  end

  def member
    context.member
  end
end
