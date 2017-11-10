# frozen_string_literal: true

module Command
  class ValidationError < StandardError
    attr_reader :messages

    def initialize(messages)
      @messages = messages
      super
    end
  end
end
