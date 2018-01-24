# frozen_string_literal: true

redis_uri = URI.parse(ENV.fetch("REDIS_URL") { "http://localhost:3000/12" })

Rails.application.configure do
  config.cache_store = :redis_store, { host: redis_uri.host, port: redis_uri.port, db: 0 }
  config.session_store :redis_store, expires_in: 1.day, servers: [{ db: 0, host: redis_uri.host }]
end
