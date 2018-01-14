# frozen_string_literal: true

module Members
  class TwoFactorController < ApplicationController
    include QrCodesHelper

    before_action :reauthenticate_member!, except: [:resend_code]
    before_action :return_to_index, only: :new, if: proc { current_member.two_factor_enabled? }
    before_action :return_to_index, only: :edit, if: proc { current_member.otp_secret_key.blank? || current_member.two_factor_enabled? }
    before_action :decorate_member, only: [:index, :new, :edit]

    def index
    end

    def new
    end

    def create
      return unless setup_params[:otp_delivery_method]
      result = TwoFactor::Setup.call(member: current_member, setup_params: setup_params)
      if result.success?
        redirect_to edit_member_settings_two_factor_path, notice: result.message
      else
        redirect_back fallback_location: member_settings_two_factor_path, alert: result.message
      end
    end

    def edit
    end

    def update
      return unless confirmation_params[:code]
      result = TwoFactor::Confirm.call(member: current_member, authentication_code: confirmation_params[:code])
      if result.success?
        redirect_to member_settings_two_factor_path, notice: result.message
      else
        redirect_to new_member_settings_two_factor_path, alert: result.message
      end
    end

    def destroy
      result = TwoFactor::Disable.call(member: current_member)
      redirect_to member_settings_two_factor_path, notice: result.message
    end

    def resend_code
      respond_to do |format|
        if session[:resend_two_factor_code] && validate_nonce(session[:resend_two_factor_code], 320.seconds)
          format.json { render json: { success: false, message: "Wait 5 minutes before requesting another code" } }
        else
          session[:resend_two_factor_code] = nonce(Time.current)
          current_member.create_direct_otp
          current_member.send_authentication_code_by_sms!
          format.json { render json: { success: true, message: "Two factor code sent" } }
        end
      end
    end

    private

    def decorate_member
      @member = current_member.decorate
    end

    def return_to_index
      notice = "You must disable two factor authentication before setting up again"
      redirect_to member_settings_two_factor_path, notice: notice
    end

    def confirmation_params
      params.require(:two_factor).permit(:code)
    end

    def setup_params
      params.require(:two_factor).permit(:phone_number, :country_code, :otp_delivery_method)
    end
  end
end
