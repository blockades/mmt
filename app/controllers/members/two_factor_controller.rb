# frozen_string_literal: true

module Members
  class TwoFactorController < ApplicationController
    include QrCodesHelper

    before_action :return_to_setup, only: [:GET_confirm, :PATCH_confirm, :GET_disable, :PATCH_disable]
    before_action :return_to_confirm, only: [:GET_setup, :PATCH_setup, :GET_disable, :PATCH_disable]
    before_action :return_to_disable, except: [:GET_confirm, :PATCH_confirm, :GET_disable, :PATCH_disable]

    def GET_setup
      respond_to do |format|
        format.html
        format.js
      end
    end

    def PATCH_setup
      if current_member.update(setup_params)
        current_member.setup_two_factor!
        redirect_to confirm_two_factor_path
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
      if current_member.authenticate_otp(confirmation_params[:code])
        if current_member.confirm_two_factor!
          redirect_to member_path(current_member), notice: "You have enabled two factor authenitcation"
        else
          redirect_back fallback_location: confirm_two_factor_path, error: "Failed to confirm two factor authentication"
        end
      else
        current_member.update(two_factor_enabled: false, otp_secret_key: nil)
        redirect_back fallback_location: setup_two_factor_path, error: "Authentication code mismatch, please try again"
      end
    end

    def GET_disable
      respond_to do |format|
        format.html
        format.js
      end
    end

    def PATCH_disable
      if current_member.valid_password?(password_params[:password])
        if current_member.disable_two_factor!
          redirect_to setup_two_factor_path, notice: "Two factor successfully disabled"
        else
          redirect_back fallback_location: disable_two_factor_path, error: "Failed to disable two factor"
        end
      else
        redirect_back fallback_location: disable_two_factor_path, alert: "Incorrect password, please try again"
      end
    end

    def cancel
      return if current_member.two_factor_enabled?
      current_member.disable_two_factor!
      redirect_to setup_two_factor_path, notice: "Two factor setup cancelled"
    end

    private

    def setup_params
      two_factor_params.merge(otp_secret_key: current_member.generate_totp_secret, otp_recovery_codes: current_member.generate_otp_recovery_codes)
    end

    def two_factor_params
      params.require(:two_factor).permit(:phone_number, :country_code)
    end

    def confirmation_params
      params.require(:two_factor).permit(:code)
    end

    def password_params
      params.require(:member).permit(:password)
    end

    def return_to_setup
      redirect_to setup_two_factor_path if !current_member.two_factor_enabled? && current_member.otp_secret_key.blank?
    end

    def return_to_confirm
      redirect_to confirm_two_factor_path if current_member.otp_setup_incomplete?
    end

    def return_to_disable
      redirect_to disable_two_factor_path if current_member.otp_setup_complete?
    end

  end
end
