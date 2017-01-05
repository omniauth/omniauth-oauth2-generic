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

**In Rails: (minimum configuration)**
```ruby
# /config/initializers/omniauth.rb
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :oauth2_generic,
      "Your_OAuth_App_ID", "Your_OAuth_App_Secret",
      client_options: {
        site: 'https://your_oauth_server', # including port if necessary
        user_info_path: '/api/path/to/fetch/current_user/info'
      }
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
    'name' => 'oauth2_genereic',
    'app_id' => 'oauth_client_app_id',
    'app_secret' => 'oauth_client_app_secret',
    'args' => {
      client_options: {
        'site' => 'https://your_oauth_server', # including port if necessary
        'user_info_path' => '/api/path/to/fetch/current_user/info'
      }
    }
  }
]
````

Now if you visit "http://yourserver/auth/oauth2generic", you should be directed to log in with your OAuth2 server.

## Configuration Options

Details about the available configuration options are provided as comments in [the OAuth2Generic class](lib/omniauth/strategies/oauth2_generic.rb).

Configuration options for this gem are separated into two categories (each provided as its own hash):

* **client_options** - options for configuring the OAuth client to point to the right URLs
* **user_attributes** - a list of [standard Omniauth user attributes](https://github.com/omniauth/omniauth/wiki/auth-hash-schema#schema-10-and-later) and the names your OAuth server uses, if not the standard names (this hash defaults to using all the standard names)

Both of these hashes have default values and your provided configuration is merged into the default, so you do no have to re-specify nested default options (although you will need to provide at least `site` and `user_info_path` in `client_options`, unless you want to use the default/example gitlab.com configuration).

In addition to those hashes, you may also specify:
* **redirect_url** - The URL the client will be directed to after authentication. Defaults to `http://yourserver/auth/oauth2generic/callback`

  Note: Your OAuth server may restrict redirects to a specific list of URLs. 
