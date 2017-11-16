describe "OmniAuth::Strategies::OAuth2Generic" do
  before do
    WebMock.disable_net_connect!
  end

  context "using default options" do
    let(:app) do
      Rack::Builder.new do
        use OmniAuth::Test::PhonySession
        use OmniAuth::Strategies::OAuth2Generic, "id123", "secretabc"
        run lambda { |env| [404, {"Content-Type" => "text/plain"}, [env.key?("omniauth.auth").to_s]] }
      end.to_app
    end

    it "responds to the default auth URL (oauth2_generic)" do
      get "/auth/oauth2_generic"
      expect(last_response).to be_redirect
    end
  end

  context "with custom provider settings" do
    let(:app) do
      Rack::Builder.new do
        use OmniAuth::Test::PhonySession
        use OmniAuth::Strategies::OAuth2Generic, "id123", "secretabc",
            name: 'custom',
            client_options: {
              site: 'https://custom.example.com',
              user_info_url: '/custom/user_info/path',
              authorize_url: '/custom/authorize/path',
              token_url: '/custom/token/path'
            },
            redirect_url: 'https://my_server.com/oauth/callback',
            user_response_structure: {
              root_path: 'user',
              attributes: { nickname: 'username' }
            },
            authorize_params: {
              custom_auth_param: ->(req) { req.params['a'] }
            }
        run lambda { |env| [404, { "Content-Type" => "applocation/json" }, [env["omniauth.auth"].to_json]] }
      end.to_app
    end

    describe "the auth endpoint (/auth/{name})" do
      before { get "/auth/custom?a=42" }

      it "responds to the custom auth URL" do
        expect(last_response).to be_redirect
      end

      it "runs lambdas in authorize_params option and includes the result" do
        redirect = URI.parse(last_response.headers["Location"])
        expect(redirect.query).to include 'custom_auth_param=42'
      end

      it "redirects to the correct custom authorize URL" do
        expect(last_response.headers["Location"]).to match(%r{\Ahttps://custom.example.com/custom/authorize/path\?})
      end

      it "passes the correct redirect URL" do
        expect(last_response.headers["Location"]).to match(%r{redirect_uri=https%3A%2F%2Fmy_server.com%2Foauth%2Fcallback&})
      end
    end

    describe "the callback (/auth/{name}/callback)" do
      before do
        # Stub custom token URL to return a stub token
        stub_request(:post, "https://custom.example.com/custom/token/path").
          to_return(body: {access_token: :atoken}.to_json, headers: {'Content-Type' => 'application/json'})
        stub_request(:get, "https://custom.example.com/custom/user_info/path").
          to_return(body: {user: {username: 'marty', id: 1}}.to_json, headers: {'Content-Type' => 'application/json'})

        # request the callback (which should request said stubbed token URL)
        get "/auth/custom/callback",
            {:state => "Caulifornia"},
            "rack.session" => { "omniauth.state" => "Caulifornia" }
      end

      let(:result_auth_hash) { JSON.parse(last_response.body) }

      it "responds to the custom callback URL and fetches a token from the custom token path" do
        expect(WebMock).to have_requested(:post, "https://custom.example.com/custom/token/path")
      end

      it "fetches user info from the custom user info path" do
        expect(WebMock).to have_requested(:get, "https://custom.example.com/custom/user_info/path")
      end

      it "sets up the auth hash for the client app" do
        expect(result_auth_hash['provider']).to eq 'custom'
      end

      it "parses user info correctly from the custom format" do
        expect(result_auth_hash['info']).to include({'nickname' => 'marty'})
        expect(result_auth_hash['uid']).to eq '1'
      end
    end
  end

end