require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class OAuth2Generic < OmniAuth::Strategies::OAuth2

      option :client_options, { # Defaults are set for GitLab example implementation
        site: 'https://gitlab.com', # The URL for your OAuth 2 server
        user_info_path: '/api/v3/user', # The endpoint on your OAuth 2 server that provides user info for the current user
        authorize_url: '/oauth/authorize', # The authorization URL for your OAuth server (shouldn't need to be changed)
        token_url: '/oauth/token' # The token request URL for your OAuth server (shouldn't need to be changed)
      }

      option :user_attributes, {
        id: 'id', # Will not show up in the `info` hash, but will be used to provide OmniAuth's required `uid` field.
        name: 'name',
        email: 'email',
        nickname: 'nickname',
        first_name: 'first_name',
        last_name: 'last_name',
        location: 'location',
        description: 'description',
        image: 'image',
        phone: 'phone',
        urls: 'urls'
      }

      option :redirect_url

      uid { raw_info[options.user_attributes['id']].to_s }

      info do
        user_info = {}
        options.user_attributes.each do |k, v|
          next if k.to_s == 'id'
          user_info[k] = raw_info[v] if raw_info[v]
        end
        user_info
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get(options.client_options[:user_info_path]).parsed
      end

      private

      def callback_url
        options.redirect_url || (full_host + script_name + callback_path)
      end
    end
  end
end

OmniAuth.config.add_camelization 'oauth2_generic', 'OAuth2Generic'