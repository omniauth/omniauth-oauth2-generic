# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class OAuth2Generic < OmniAuth::Strategies::OAuth2

      option :name, 'oauth2_generic'

      option :client_options,
             {
               # Defaults are set for GitLab example implementation

               # The URL for your OAuth 2 server
               site: 'https://gitlab.com',
               # The endpoint on your OAuth 2 server that provides info for the current user
               user_info_url: '/api/v3/user',
               # The authorization endpoint for your OAuth server
               authorize_url: '/oauth/authorize',
               # The token request endpoint for your OAuth server
               token_url: '/oauth/token'
             }

      option :user_response_structure,
             {
               # info about the structure of the response from the oauth server's user_info_url (specified above)

               # The default path to the user attributes (i.e. ['data', 'attributes'])
               root_path: [],

               # The name or path to the user ID (i.e. ['data', 'id]').
               # Scalars are considered relative to `root_path`, Arrays are absolute paths.
               id_path: 'id',

               # Alternate paths or names for any attributes that don't match the default
               attributes: {
                 # Scalars are treated as relative (i.e. 'username' would point to
                 # response['data']['attributes']['username'], given a root_path of ['data', 'attributes'])
                 name: 'name',

                 # Arrays are treated as absolute paths (i.e. ['included', 'contacts', 0, 'email'] would point to
                 # response['included']['contacts'][0]['email'], regardless of root_path)
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
             }

      option :redirect_url

      uid do
        fetch_user_info(user_paths[:id_path]).to_s
      end

      info do
        user_paths[:attributes].each_with_object({}) do |(field, path), user_hash|
          value = fetch_user_info(path)
          user_hash[field] = value if value
        end
      end

      extra do
        { raw_info: raw_info }
      end


      def raw_info
        @raw_info ||= access_token.get(options.client_options[:user_info_url]).parsed
      end


      def authorize_params
        params = super
        params.transform_values { |v| v.respond_to?(:call) ? v.call(request) : v }
      end


      private


        def user_paths
          options.user_response_structure
        end


        def fetch_user_info(path)
          return nil unless path

          full_path = path.is_a?(Array) ? path : Array(user_paths[:root_path]) + [path]
          full_path.inject(raw_info) do |info, key|
            info[key]
          rescue StandardError
            nil
          end
        end


        def callback_url
          options.redirect_url || (full_host + script_name + callback_path)
        end
    end
  end
end

OmniAuth.config.add_camelization 'oauth2_generic', 'OAuth2Generic'
