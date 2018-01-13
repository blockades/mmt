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
require "rqrcode"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MMT
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/app/**/", "#{config.root}/lib/**/"]

    config.before_initialize do
      require config.root.join "config", "initializers", "magic_money_tree"
    end
  end
end
