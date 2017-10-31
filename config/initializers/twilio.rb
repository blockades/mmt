require 'twilio-ruby'

module TwilioClient

  mattr_reader :account_sid, :auth_token
  @@account_sid = ENV.fetch('TWILIO_ACCOUNT_SID')
  @@auth_token = ENV.fetch('TWILIO_AUTH_TOKEN')

  class << self

    def connection
      @connection ||= Twilio::REST::Client.new account_sid, auth_token
    end

    def send_message(to:, from: ENV.fetch('TWILIO_PHONE_NUMBER'), body:)
      connection.api.account.messages.create(
        from: from,
        to: to,
        body: body
      )
    end

  end
end
