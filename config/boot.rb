# frozen_string_literal: true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "rails/commands/server"

module DefaultOptions
  def default_options
    super.merge!(Host: "0.0.0.0", Port: 5000)
  end
end

Rails::Server.send(:prepend, DefaultOptions)
