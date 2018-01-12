# frozen_string_literal: true

module TwoFactor
  class Disable
    include Interactor

    def call
      if member.update(otp_secret_key: nil, two_factor_enabled: false, otp_delivery_method: nil)
        context.message = "Two factor authentication disabled"
      else
        context.fail!(message: "Failed to disable two factor authentication")
      end
    end

    private

    def member
      context.member
    end
  end
end
