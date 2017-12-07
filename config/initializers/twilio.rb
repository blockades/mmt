# frozen_string_literal: true

require "twilio-ruby"

module TwilioClient
  class << self
    def account_sid
      ENV["TWILIO_ACCOUNT_SID"]
    end

    def auth_token
      ENV["TWILIO_AUTH_TOKEN"]
    end

    def connection
      @connection ||= Twilio::REST::Client.new account_sid, auth_token
    end

    def send_message(to:, from: ENV.fetch("TWILIO_PHONE_NUMBER"), body:)
      connection.api.account.messages.create(
        from: from,
        to: to,
        body: body
      )
    end
  end
end
