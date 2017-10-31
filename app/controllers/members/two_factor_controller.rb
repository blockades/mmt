# frozen_string_literal: true

module Members
  class TwoFactorController < ApplicationController
    include QrCodesHelper

    before_action :reauthenticate_member!

    def index
    end

    def new
    end

    def create
      ActiveRecord::Base.transaction do
        if current_member.update(two_factor_setup_params)
          if current_member.setup_two_factor!
            redirect_to edit_two_factor_path, notice: "Delivery method assigned. Please continue to confirm two factor authentication"
          else
            redirect_back fallback_location: two_factor_path, error: "Failed to setup two factor authentication. Please try again"
          end
        else
          redirect_back fallback_location: two_factor_path, error: "Failed to assign a delivery method. Please try again"
        end
      end
    end

    def edit
      redirect_to two_factor_path unless current_member.otp_secret_key.present?
      # %%TODO%% Do we want to save this?
      # Also render the QRcode as a PNG on the fly using Dragonfly?
      @qr_code = qr_code_as_html(provisioning_uri)
    end

    def update
      return unless two_factor_confirm_params[:code]
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

    def phone_details_present?
     two_factor_setup_params.has_key?(:phone_number) || two_factor_setup_params.has_key?(:country_code)
    end

    def two_factor_confirm_params
      params.require(:two_factor).permit(:code)
    end

    def two_factor_setup_params
      params.require(:two_factor).permit(:phone_number, :country_code, :otp_delivery_method)
    end
  end
end
