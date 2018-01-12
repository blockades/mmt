# frozen_string_literal: true

module Authentication
  class TwoFactor
    include Interactor

    def call
      if member.two_factor_enabled?
        check_for_authentication_code
        authenticate_by_two_factor
        context.message = "Succesfully authenticated"
      else
        context.message = "Two factor not enabled"
      end
    end

    protected

    def check_for_authentication_code
      return if authentication_code.present?
      context.fail!(message: "Two factor authentication required. Please enter a code")
    end

    def authenticate_by_two_factor
      return if member.authenticate_otp(authentication_code)
      context.fail!(message: "Two factor authentication failed")
    end

    private

    def member
      context.member
    end

    def authentication_code
      context.password_params[:authentication_code]
    end
  end
end
