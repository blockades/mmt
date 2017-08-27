# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "acts_as_paranoid"
gem "coffee-rails", "~> 4.2"
gem "pg"
gem "puma", "~> 3.0"
gem "rails", "~> 5.0.5"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"

gem "devise"
gem "interactor-rails"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "turbolinks", "~> 5"

gem "blockchain-api"
gem "coinbase"
gem "kraken_ruby"

gem "slim-rails"

# gem 'capistrano-rails', group: :development

group :development, :test do
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
  gem "factory_girl_rails"
  gem "faker"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "simplecov"
  gem "timecop"
  gem "webmock"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
