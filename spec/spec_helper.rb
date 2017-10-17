# frozen_string_literal: true

require "simplecov"
require "webmock/rspec"

SimpleCov.start "rails" do
  add_filter "/app/channels"
  add_filter "/app/jobs"
end

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
  def json_fixture(name)
    File.read(Rails.root.join('spec/support/fixtures', name+'.json'))
  end
end
