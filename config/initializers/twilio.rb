# frozen_string_literal: true

module TwilioClient
  def self.connection
    @connection ||= Twilio::REST::Client.new(ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_AUTH_TOKEN'))
  end
end
