# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "blockchain-api"
gem "coinbase"
gem "devise"
gem "devise_invitable"
gem "draper"
gem "font-awesome-rails"
gem "friendly_id", "~> 5.1.0"
gem "interactor-rails"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "kraken_ruby"
gem "pg"
gem "puma", "~> 3.0"
gem "rails", "~> 5.1.0"
gem "redis-rails"
gem "rqrcode-with-patches", "~> 0.5.4"
gem "sass-rails", "~> 5.0"
gem "slim-rails"
gem "select2-rails"
gem "sidekiq"
gem "slim-rails"
gem "state_machine"
gem "turbolinks", "~> 5"
gem "twilio-ruby", "~> 5.4.3"
gem "two_factor_authentication"
gem "two_factor_recovery", git: "https://github.com/KGibb8/two_factor_recoverable"
gem "uglifier", ">= 1.3.0"

group :development, :test do
  gem "awesome_print"
  gem "pry-byebug", platform: :mri
end

group :development do
  gem "dotenv-rails"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "faker"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "rspec-sidekiq"
  gem "simplecov"
  gem "timecop"
  gem "webmock"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
