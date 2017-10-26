# frozen_string_literal: true

module Members
  class TwoFactorController < ApplicationController
    include TwoFactorHelper

    before_action :return_to_setup, only: [:GET_confirm, :PATCH_confirm, :GET_disable, :PATCH_disable], unless: :otp_setup_initiated
    before_action :return_to_confirm, except: [:GET_confirm, :PATCH_confirm], if: :otp_setup_incomplete
    before_action :return_to_disable, except: [:GET_disable, :PATCH_disable], if: :otp_setup_complete

    def GET_setup
      respond_to do |format|
        format.html
        format.js
      end
    end

    def PATCH_setup
      current_member.otp_secret = Member.generate_otp_secret
      if current_member.update(two_factor_params.merge(otp_setup_initiated: true))
        redirect_to confirm_two_factor_members_path
      else
        redirect_back fallback_location: member_path(current_member), error: "Failed to setup two factor authentication"
      end
    end

    def GET_confirm
      respond_to do |format|
        format.html
        format.js
      end
    end

    def PATCH_confirm
      if current_member.current_otp == code_confirmation_params[:code]
        current_member.otp_required_for_login = true
        current_member.save!
        redirect_to member_path(current_member), notice: "You have enabled two factor authenitcation"
      else
        current_member.update(otp_setup_initiated: false, otp_required_for_login: true)
        redirect_back fallback_location: setup_two_factor_members_path, error: "Authentication code mismatch, please try again"
      end
    end

    def GET_disable
      respond_to do |format|
        format.html
        format.js
      end
    end

    def PATCH_disable
      current_member.update(otp_required_for_login: false, otp_setup_initiated: false)
      redirect_to setup_two_factor_members_path
    end

    private

    def two_factor_params
      params.require(:two_factor).permit(:phone_number, :country_code)
    end

    def code_confirmation_params
      params.require(:two_factor).permit(:code)
    end

    def return_to_setup
      redirect_to setup_two_factor_members_path
    end

    def return_to_confirm
      redirect_to confirm_two_factor_members_path
    end

    def return_to_disable
      redirect_to disable_two_factor_members_path
    end

    def otp_setup_initiated
      current_member.otp_setup_initiated?
    end

    def otp_setup_incomplete
      current_member.otp_setup_incomplete
    end

    def otp_setup_complete
      current_member.otp_setup_complete
    end

  end
end
