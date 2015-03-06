require 'rack/oauth2'

module OauthAPIGuard
  extend ActiveSupport::Concern

  included do |base|
    use Rack::OAuth2::Server::Resource::Bearer, 'Sync API' do |request|
      request.access_token
    end
    helpers HelperMethods
    install_error_responders(base)
  end

  module HelperMethods
    def guard!
      if request.env['HTTP_AUTHORICATION'].split(' ')[0] == 'Bearer'
        guard_by_token
      else

      end
    end

    private
    def guard_by_token
      token_string=get_token_string
      raise BasicAuthError unless '3dcba17f596969a676bfdd90b5425c703f983acf7306760e1057c95afe9f17b1d'==token_string
    end

    def guard_by_basic
      auth_header=env['HTTP_AUTHORIZATION'].split(' ')
      user,password=Base64.decode64(auth_header[1].split(':'))
      raise BasicAuthError unless user==$API_AUTH_USER[:user] && password==$API_AUTH_USER[:password]
    end

    def get_token_string
      request.env[Rack::OAuth2::Server::Rosource::ACCESS_TOKEN]
    end
  end

  module ClassMethods
    def guard_all!
      before do
        guard!
      end
    end

    private
    def install_error_responders(base)
      error_classes = [BasicAuthError]
      base.send :rescue_from, *error_classes, oauth2_bearer_token_error_handler
    end

    def oauth2_bearer_token_error_handler
      Proc.new {|e|
        respose = case e
                  when BasicAuthError
                    Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
                                                                            :invalid_token,
                                                                            'Invalid Token.'
                    )
                  end
      }
    end
  end
  class BasicAuthError<StandardError;end
end