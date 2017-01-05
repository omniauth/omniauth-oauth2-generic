# omniauth-oauth2-generic

By [Internet Exposure](https://www.iexposure.com/)

[![build](http://gitlab.iexposure.com/satorix/omniauth-oauth2-generic/badges/master/build.svg)](http://gitlab.iexposure.com/satorix/omniauth-oauth2-generic/pipelines)
[![coverage](http://gitlab.iexposure.com/satorix/omniauth-oauth2-generic/badges/master/coverage.svg)](http://gitlab.iexposure.com/satorix/omniauth-oauth2-generic/pipelines)

This gem provides an OmniAuth strategy for authenticating with an OAuth2 service using the authorization grant flow.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-oauth2-generic'
```

## Usage

Include this gem in your client app [as you would any OmniAuth strategy](https://github.com/omniauth/omniauth#getting-started), by adding it to the middleware stack:

**In Rails:**
```ruby
# /config/initializers/omniauth.rb
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :oauth2_generic,
      ENV['OAUTH_APP_ID'], ENV['OAUTH_APP_SECRET'],
      oauth_host: 'http://localhost:3000' # Host to direct OAuth requests to
  end
```

**In Gitlab Config:**

```ruby
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = ['oauth2_generic']
gitlab_rails['omniauth_auto_sign_in_with_provider'] = 'oauth2_generic'
gitlab_rails['omniauth_block_auto_created_users'] = false
gitlab_rails['omniauth_providers'] = [
  {
    "name" => "oauth2_genereic",
    "app_id" => "client_app_id",
    "app_secret" => "client_app_secret",
    "args" => {oauth_host: "http://optional.test.host"}
  }
]
````

## Development

**Boilerplate:**

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

