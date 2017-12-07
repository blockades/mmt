# frozen_string_literal: true

module Workers
  class Base
    include Sidekiq::Worker

    def send_error_message(error)
      Rails.logger.error("\n#{error.message}\n\t#{error.backtrace.join("\n\t")}\n")
    end
  end
end
