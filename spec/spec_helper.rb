# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'rack/test'
require 'webmock/rspec'
require 'omniauth-oauth2-generic'

RSpec.configure do |config|
  config.extend OmniAuth::Test::StrategyMacros, type: :strategy
  config.include Rack::Test::Methods
  config.include WebMock::API
end
