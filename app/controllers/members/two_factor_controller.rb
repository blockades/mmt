# frozen_string_literal: true

module Members
  class TwoFactorController < ApplicationController
    include QrCodesHelper

    before_action :reauthenticate_member!, except: [:resend_code]
    before_action :return_to_index, only: :new, if: proc { current_member.two_factor_enabled? }
    before_action :return_to_index, only: :edit, if: proc { current_member.otp_secret_key.blank? || current_member.two_factor_enabled? }

    def index
    end

    def new
    end

    def create
      return unless setup_params[:otp_delivery_method]
      if current_member.setup_two_factor!(setup_params)
        redirect_to edit_member_settings_two_factor_path, notice: "Delivery method assigned. Please continue to confirm two factor authentication"
      else
        redirect_back fallback_location: member_settings_two_factor_path, error: "Failed to setup two factor authentication. Please try again"
      end
    end

    def edit
    end

    def update
      return unless confirmation_params[:code]
      if current_member.confirm_two_factor!(confirmation_params[:code])
        redirect_to member_settings_two_factor_path, notice: "You have enabled two factor authenitcation"
      else
        current_member.update(two_factor_enabled: false, otp_secret_key: nil, otp_delivery_method: nil)
        redirect_to new_member_settings_two_factor_path, error: "Authentication code mismatch, please try again"
      end
    end

    def destroy
      notice = current_member.disable_two_factor! ? "Two factor authentication disabled" : "Failed to disable two factor authentication"
      redirect_to member_settings_two_factor_path, notice: notice
    end

    def resend_code
      current_member.send_new_direct_otp_code_sms!

      respond_to do |format|
        format.json { render json: { success: true, message: "Two factor code sent" } }
      end
    end

    private

    def return_to_index
      redirect_to member_settings_two_factor_path, notice: "You must disable two factor authentication before setting up again"
    end

    def phone_details_present?
      setup_params.has_key?(:phone_number) || setup_params.has_key?(:country_code)
    end

    def confirmation_params
      params.require(:two_factor).permit(:code)
    end

    def setup_params
      params.require(:two_factor).permit(:phone_number, :country_code, :otp_delivery_method)
    end
  end
end
