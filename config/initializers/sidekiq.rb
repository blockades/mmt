# frozen_string_literal: true

require "sidekiq"

redis_url = ENV.fetch("REDIS_URL") { 'redis://localhost:6379/12'}

Sidekiq.configure_server do |config|
  config.redis = {
    url: redis_url
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: redis_url
  }
end
