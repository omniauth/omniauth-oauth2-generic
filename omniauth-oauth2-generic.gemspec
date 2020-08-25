# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-oauth2-generic/version'

Gem::Specification.new do |gem|
  gem.name = 'omniauth-oauth2-generic'
  gem.version = Omniauth::OAuth2Generic::VERSION
  gem.authors = ['Satorix']
  gem.email = ['satorix@iexposure.com']

  gem.summary = 'Generic, Configurable OmniAuth Strategy for OAuth2 providers'
  gem.description = gem.summary
  gem.homepage = 'https://gitlab.com/satorix/omniauth-oauth2-generic'
  gem.license = 'MIT'

  gem.required_ruby_version = '>= 1.9'

  gem.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  gem.require_paths = ['lib']

  gem.add_dependency 'omniauth-oauth2', '~> 1.0'
  gem.add_dependency 'rake'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'webmock'
end
