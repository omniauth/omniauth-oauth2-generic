require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class OAuth2Generic < OmniAuth::Strategies::OAuth2

      option :client_options, { # Defaults are set for GitLab example implementation
        site: 'https://gitlab.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token',
        user_info_url: '/api/v3/user'
      }

      option :redirect_url

      uid { raw_info['id'].to_s }

      info do
        raw_info.slice('name', 'username', 'email')
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get(options.client_options[:user_info_url]).parsed
      end

      private

      def callback_url
        options.redirect_url || (full_host + script_name + callback_path)
      end
    end
  end
end

OmniAuth.config.add_camelization 'oauth2_generic', 'OAuth2Generic'