# frozen_string_literal: true

redis_host = ENV.fetch('REDIS_HOST') { 'localhost' }
redis_namespace = ENV.fetch('REDIS_NAMESPACE') { Rails.env }

Rails.application.configure do

  config.cache_store = :redis_store, { host: redis_host, port: 6379, db: 0 }
  config.session_store :redis_store, expires_in: 1.day, servers: [ { db: 0, host: redis_host } ]

end
