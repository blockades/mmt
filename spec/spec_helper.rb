# frozen_string_literal: true

require "simplecov"
require "webmock/rspec"
require "securerandom"

SimpleCov.start "rails" do
  add_filter "/app/channels"
  add_filter "/app/jobs"
end

ENV["OTP_SECRET_ENCRYPTION_KEY"] = Digest::SHA2.hexdigest 'SUPER_DUPER_SECRET_KEY'
ENV["NONCE_SECRET"] = SecureRandom.hex

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end

module SpecHelperMethods
  def reauthenticate!
    @request.session[:reauthenticated_at] = Time.now
  end

  def nonce(time)
    ActionController::HttpAuthentication::Digest.nonce(ENV.fetch('NONCE_SECRET'), time)
  end

  def json_fixture(name)
    File.read(Rails.root.join('spec/support/fixtures', name+'.json'))
  end
end
