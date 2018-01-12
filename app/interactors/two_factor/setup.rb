# frozen_string_literal: true

module TwoFactor
  class Setup
    include Interactor

    def call
      ActiveRecord::Base.transaction do
        setup_otp_delivery_method!
        unless setup_by_method.nil?
          setup_by_method.call
          context.message = success_message
        else
          context.fail!(message: "Invalid delivery method")
          throw(:abort)
        end
      end
    end

    protected

    def setup_otp_delivery_method!
      return if member.update otp_delivery_method: setup_params[:otp_delivery_method]
      context.fail!(message: member.errors.full_messages.to_sentence)
    end

    def setup_by_method
      {
        app: -> { setup_by_app! },
        sms: -> { setup_by_phone! }
      }.with_indifferent_access[member.otp_delivery_method]
    end

    def setup_by_app!
      return if member.update app_params
      context.fail!(message: member.errors.full_messages.to_sentence)
    end

    def setup_by_phone!
      if member.update phone_params
        member.create_direct_otp
        member.send_authentication_code_by_sms!
      else
        context.fail!(message: member.errors.full_messages.to_sentence)
      end
    end

    def success_message
      <<-STRING.delete("\n").squish
        Setup authentication by #{Member::TWO_FACTOR_DELIVERY_METHODS[member.otp_delivery_method]}.
        Please continue to confirm two factor authentication
      STRING
    end

    private

    def setup_params
      context.setup_params
    end

    def app_params
      {
        otp_secret_key: member.generate_totp_secret,
        otp_recovery_codes: member.generate_otp_recovery_codes
      }
    end

    def phone_params
      {
        phone_number: setup_params[:phone_number],
        country_code: setup_params[:country_code],
        otp_recovery_codes: member.generate_otp_recovery_codes
      }
    end

    def member
      context.member
    end
  end
end
