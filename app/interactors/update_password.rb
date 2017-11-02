# frozen_string_literal: true

class UpdatePassword
  include Interactor

  def call
    if member.two_factor_enabled?
      check_for_authentication_code
      authenticate_by_two_factor
      update_password!
      context.message = "Succesfully updated password"
    else
      update_password!
      context.message = "Succesfully updated password"
    end
  end

  def check_for_authentication_code
    context.fail!(message: "Two factor authentication required. Please enter a code") unless authentication_code.present?
  end

  def authenticate_by_two_factor
    context.fail!(message: "Two factor authentication failed") unless member.authenticate_otp(authentication_code)
  end

  def update_password!
    context.fail!(message: "Failed to update password") unless member.update! password_params
  end

  private

  def member
    context.member
  end

  def password_params
    context.password_params.except(:authentication_code)
  end

  def authentication_code
    context.password_params[:authentication_code]
  end
end

