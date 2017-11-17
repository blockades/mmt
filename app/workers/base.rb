# frozen_string_literal: true

module Workers
  class Base
    include Sidekiq::Worker

    def send_error_message(error)
      Rails.logger.error("\n#{e.message}\n\t#{e.backtrace.join("\n\t")}\n")
    end
  end
end
