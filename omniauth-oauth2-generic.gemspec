# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-oauth2-generic/version'

Gem::Specification.new do |spec|
  spec.name = 'omniauth-oauth2-generic'
  spec.version = Omniauth::OAuth2Generic::VERSION
  spec.authors = ['Satorix']
  spec.email = ['satorix@iexposure.com']

  spec.summary = 'Generic, Configurable OmniAuth Strategy for OAuth2 providers'
  spec.description = spec.summary
  spec.homepage = 'https://gitlab.com/satorix/omniauth-oauth2-generic'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'omniauth-oauth2', '~> 1.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'webmock'
end
