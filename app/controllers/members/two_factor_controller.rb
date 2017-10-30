# frozen_string_literal: true

module Members
  class TwoFactorController < ApplicationController
    include QrCodesHelper

    before_action :reauthenticate_member!

    def index
    end

    def new
      redirect_to edit_two_factor_settings_path if current_member.otp_secret_key.present?
    end

    def create
      return if current_member.otp_secret_key.present?
      if current_member.setup_two_factor!
        redirect_to edit_settings_two_factor_path
      else
        redirect_back fallback_location: two_factor_settings_path
      end
    end

    def edit
      redirect_to two_factor_settings_path unless current_member.otp_secret_key.present?
    end

    def update
      if current_member.authenticate_otp(two_factor_params[:code])
        notice = current_member.confirm_two_factor!(two_factor_params[:otp_delivery_method]) ? "You have enabled two factor authenitcation" : "Failed to confirm two factor authentication"
        redirect_to two_factor_settings_path, notice: notice
      else
        current_member.update(two_factor_enabled: false, otp_secret_key: nil, otp_delivery_method: nil)
        redirect_back fallback_location: two_factor_settings_path, error: "Authentication code mismatch, please try again"
      end
    end

    def destroy
      notice = current_member.disable_two_factor! ? "Two factor authentication disabled" : "Failed to disable two factor authentication"
      redirect_to two_factor_settings_path, notice: notice
    end

    private

    def two_factor_params
      params.require(:two_factor).permit(:code, :otp_delivery_method)
    end
  end
end
