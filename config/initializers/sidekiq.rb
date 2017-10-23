require 'sidekiq'

redis_host = ENV.fetch( 'REDIS_HOST' ) { 'localhost' }

Sidekiq.configure_server do |config|
  config.redis = {
    url: "redis://#{redis_host}:6379",
    # namespace: ENV.fetch( 'REDIS_NAMESPACE' ) { Rails.env }
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: "redis://#{redis_host}:6379",
    # namespace: ENV.fetch( 'REDIS_NAMESPACE' ) { Rails.env }
  }
end
