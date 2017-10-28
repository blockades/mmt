# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: "_MMT_session"
# Rails.application.config.session_store :redis_store, expires_in: 1.day, servers: [ { db: 0, host: ENV.fetch('REDIS_HOST') { 'localhost' } } ]
