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

**Rails Example: (minimum configuration)**
```ruby
# config/initializers/omniauth.rb
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :oauth2_generic,
      "Your_OAuth_App_ID", "Your_OAuth_App_Secret",
      client_options: {
        site: 'https://your_oauth_server', # including port if necessary
        user_info_url: '/api/path/to/fetch/current_user/info'
      },
      name: 'Satorix' # optional - alternate name for the strategy (appears in URLs)
  end
```

**Gitlab Config Example:**

```ruby
# /etc/gitlab/gitlab.rb
gitlab_rails['omniauth_enabled'] = true
gitlab_rails['omniauth_allow_single_sign_on'] = ['oauth2_generic']
gitlab_rails['omniauth_block_auto_created_users'] = false
gitlab_rails['omniauth_providers'] = [
  {
    'name' => 'oauth2_generic',
    'app_id' => 'oauth_client_app_id',
    'app_secret' => 'oauth_client_app_secret',
    'args' => {
      client_options: {
        'site' => 'https://your_oauth_server', # including port if necessary
        'user_info_url' => '/api/path/to/fetch/current_user/info'
      },
      # optionally, you can add the following two lines to "white label" the display name
      # of this strategy (appears in urls and Gitlab login buttons)
      # If you do this, you must also replace oauth2_generic, everywhere it appears above, with the new name. 
      name: 'Satorix', # display name for this strategy
      strategy_class: "OmniAuth::Strategies::OAuth2Generic" # Devise-specific config option Gitlab uses to find renamed strategy
    }
  }
]
````

Now if you visit `http://yourserver/auth/oauth2_generic` (or `/auth/Satorix` for the custom name example), you should be directed to log in with your OAuth2 server.

## Configuration Options

Details about the available configuration options are provided as comments in [the OAuth2Generic class](lib/omniauth/strategies/oauth2_generic.rb).

Configuration options for this gem are:

* **client_options** - A Hash containing options for configuring the OAuth client to point to the right URLs
* **user_response_structure** - A Hash containing paths to various attributes of the user in the response that your OAuth server returns from the `user_info_url` specified in the `client_options`.
  * **root_path** - An Array containing each key in the path to the node that contains the user attributes (i.e. `['data', 'attributes']` for a JsonAPI-formatted response)
  * **id_path** - A String containing the name, or Array containing the keys in the path to the node that contains the user's ID (i.e. `['data', 'id']` for a JsonAPI-formatted response). Default: `'id'` (string values are assumed to be relative to the `root_path`)
  * **attributes** - A Hash containing [standard Omniauth user attributes](https://github.com/omniauth/omniauth/wiki/auth-hash-schema#schema-10-and-later) and the names/paths to them in the response, if not the standard names (this hash defaults to looking for the standard names under the specified `root_path`)
  
    **Note:** The entire raw response will also be returned in the `['extra']['raw_info']` field of the OmniAuth auth hash, regardless of the value of this option.
* **redirect_url** - The URL the client will be directed to after authentication. Defaults to `http://yourserver/auth/oauth2_generic/callback`

  **Note:** Your OAuth server may restrict redirects to a specific list of URLs.
* **name** - A String.  If set, this changes the name of the strategy used in the URLs and sometimes other places (the login button in Gitlab, for instance)
  
The hash options have default values for all keys, and your provided configuration is merged into the default, so you do not have to re-specify nested default options (although you will need to provide at least `site` and `user_info_url` in `client_options`, unless you want to use the default/example gitlab.com configuration). 
