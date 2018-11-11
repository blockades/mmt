# frozen_string_literal: true

module Members
  class PasswordsController < ApplicationController
    def edit
      @member = current_member.decorate
    end

    def update
      if change_password.success?
        bypass_sign_in current_member
        redirect_to member_path(current_member), notice: change_password.message
      else
        redirect_back fallback_location: edit_member_settings_password_path, alert: change_password.message
      end
    end

    private

    def change_password
      ChangePassword.call(
        member: current_member,
        password: current_password_params[:current_password],
        password_params: password_params
      )
    end

    def current_password_params
      params.require(:member).permit(:current_password)
    end

    def password_params
      params.require(:member).permit(:password, :password_confirmation, :authentication_code)
    end
  end
end
