# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require 'rqrcode'
require 'aggregate_root'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MMT
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/app/**/"]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.event_store = RailsEventStore::Client.new(
      event_broker: RailsEventStore::EventBroker.new(
        dispatcher: RailsEventStore::ActiveJobDispatcher.new(
          proxy_strategy: RailsEventStore::AsyncProxyStrategy::AfterCommit.new
        )
      )
    )

    config.before_initialize do
      require config.root.join 'config', 'initializers', 'magic_money_tree'
    end
  end

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.application.config.event_store
  end
end
