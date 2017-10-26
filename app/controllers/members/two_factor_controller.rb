# frozen_string_literal: true

module Members
  class TwoFactorController < ApplicationController
    include TwoFactorHelper

    before_action :redirect_to_setup, only: [:code, :confirm], if: proc { !current_member.otp_setup_initiated }

    def setup
    end

    def update
      current_member.otp_secret = Member.generate_otp_secret
      if current_member.update(two_factor_params)
        if current_member.otp_setup_initiated?
          redirect_to two_factor_code_members_path
        else
          redirect_back fallback_location: member_path(current_member)
        end
      else
        redirect_back fallback_location: member_path(current_member)
      end
    end

    def code
    end

    def confirm
      if current_member.current_otp == code_confirmation_params[:code]
        current_member.otp_required_for_login = true
        current_member.save!
        redirect_to member_path(current_member), notice: "You have enabled two factor authenitcation"
      else
        current_member.update(otp_setup_initiated: false)
        redirect_back fallback_location: setup_two_factor_members_path, notice: "Authentication code mismatch, please try again"
      end
    end

    private

    def two_factor_params
      params.require(:two_factor).permit(:otp_required_for_login, :otp_setup_initiated, :phone_number, :country_code)
    end

    def code_confirmation_params
      params.require(:two_factor).permit(:code)
    end

    def redirect_to_setup
      redirect_to setup_two_factor_members_path
    end

  end
end
