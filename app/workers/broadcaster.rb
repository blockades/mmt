# frozen_string_literal: true

module Workers
  class Broadcaster < Workers::Base

    def perform(options = {})
      channel = options.fetch('channel')
      data = options.fetch('data')
      ActionCable.server.broadcast(channel, data)
    end

  end
end
