# frozen_string_literal: true

module Members
  class MembersController < ApplicationController
    before_action :find_member, only: [:show, :update]

    def show
    end

    def update
      respond_to do |format|
        if @member.update member_params
          format.html { redirect_to member_path(@member), notice: "Successfully updated" }
          format.json { render json: { success: true, member: @member } }
        else
          format.html { redirect_to member_path(@member), error: "Failed to update" }
          format.json { render json: { success: false, errors: @member.errors, member: @member } }
        end
      end
    end

    def update_password
      if current_member.otp_setup_complete
        if two_factor_params[:otp_code].blank?
          redirect_to member_path(current_member), alert: "Two factor authentication required. Please enter a code" and return
        end
        if current_member.authenticate_otp(two_factor_params[:otp_code])
          current_member.update password_params
          sign_in current_member, bypass: true
          redirect_to member_path(current_member), notice: "Successfully update password"
        else
          redirect_to member_path(current_member), alert: "Two factor authentication failed" 
        end
      else
        if current_member.update password_params
          sign_in current_member, bypass: true
          redirect_to member_path(current_member), notice: "Succesfully updated password"
        else
          redirect_to member_path(current_member), error: "Failed to update password"
        end
      end
    end

    private

    def find_member
      @member = params[:id] ? Member.friendly.find(params[:id]) : current_member
    end

    def member_params
      params.require(:member).permit(:username)
    end

    def two_factor_params
      params.require(:member).permit(:otp_code)
    end

    def password_params
      params.require(:member).permit(:password, :password_confirmation)
    end
  end
end
