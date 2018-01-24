# frozen_string_literal: true

module Workers
  class SmsAuthentication < Workers::Base
    sidekiq_options queue: :two_factor, retry: false, backtrace: true

    def perform(phone_number, body)
      TwilioClient.send_message(to: phone_number, body: body)
    end
  end
end
