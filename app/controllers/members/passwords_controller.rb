module Members
  class PasswordsController < ApplicationController
    before_action :find_member, only: [:update]

    def new
    end

    def update
      if current_member.two_factor_enabled?
        if two_factor_params[:otp_code].blank?
          redirect_to member_path(current_member), alert: "Two factor authentication required. Please enter a code" and return
        end
        if current_member.authenticate_otp(two_factor_params[:otp_code])
          current_member.update password_params
          bypass_sign_in current_member
          redirect_to member_path(current_member), notice: "Successfully updated password"
        else
          redirect_to member_path(current_member), alert: "Two factor authentication failed" 
        end
      else
        if current_member.update password_params
          bypass_sign_in current_member
          redirect_to member_path(current_member), notice: "Succesfully updated password"
        else
          redirect_to member_path(current_member), error: "Failed to update password"
        end
      end
    end

    private

    def password_params
      params.require(:member).permit(:password, :password_confirmation)
    end

    def two_factor_params
      params.require(:two_factor).permit(:otp_code)
    end

    def find_member
      @member = Member.friendly.find_by(params[:id])
    end

  end
end
