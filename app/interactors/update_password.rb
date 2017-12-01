# frozen_string_literal: true

class UpdatePassword
  include Interactor

  def call
    update_password!
    context.message = "Succesfully updated password"
  end

  protected

  def update_password!
    return if member.update! password_params
    context.fail!(message: "Failed to update password")
  end

  private

  def member
    context.member
  end

  def password_params
    context.password_params.except(:authentication_code)
  end
end
