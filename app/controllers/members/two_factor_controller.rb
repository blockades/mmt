# frozen_string_literal: true

module Members
  class TwoFactorController < ApplicationController
    include QrCodesHelper

    before_action :reauthenticate_member!

    def index
    end

    def create
      if current_member.setup_two_factor!
        redirect_to edit_two_factor_path
      else
        redirect_back fallback_location: two_factor_path
      end
    end

    def edit
      redirect_to two_factor_path unless current_member.otp_secret_key.present?
      # %%TODO%% Do we want to save this?
      # Also render the QRcode as a PNG on the fly using Dragonfly?
      @qr_code = qr_code_as_html(provisioning_uri)
    end

    def update
      return unless two_factor_params[:code]
      if current_member.authenticate_otp(two_factor_params[:code])
        notice = current_member.confirm_two_factor!(two_factor_params[:otp_delivery_method]) ? "You have enabled two factor authenitcation" : "Failed to confirm two factor authentication"
        redirect_to two_factor_path, notice: notice
      else
        current_member.update(two_factor_enabled: false, otp_secret_key: nil, otp_delivery_method: nil)
        redirect_to two_factor_path, error: "Authentication code mismatch, please try again"
      end
    end

    def destroy
      notice = current_member.disable_two_factor! ? "Two factor authentication disabled" : "Failed to disable two factor authentication"
      redirect_to two_factor_path, notice: notice
    end

    private

    def two_factor_params
      params.require(:two_factor).permit(:code, :otp_delivery_method)
    end
  end
end
