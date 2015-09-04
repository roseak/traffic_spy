ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara'
require 'database_cleaner'
require 'tilt/erb'

Capybara.app = TrafficSpy::Server

class FeatureTest < Minitest::Test
  include Capybara::DSL
end

DatabaseCleaner.strategy = :truncation, { except: %w[public.schema_migrations] }
