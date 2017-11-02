module Members
  class PasswordsController < ApplicationController

    def new
      @member = current_member.decorate
    end

    def update
      result = UpdatePassword.call(member: current_member, password_params: password_params)
      if result.success?
        bypass_sign_in current_member
        redirect_to member_path(current_member), notice: result.message
      else
        redirect_back fallback_location: new_member_settings_password_path, alert: result.message
      end
    end

    private

    def password_params
      params.require(:member).permit(:password, :password_confirmation, :authentication_code)
    end

  end
end
