require 'sinatra'
require 'rack-flash'
require 'rack/ssl-enforcer'

# Basic class for UrlShortner Web Application
class UrlShortnerApp < Sinatra::Base
  enable :logging

  use Rack::Session::Cookie, secret: ENV['MSG_KEY']
  use Rack::Flash

  configure :production do
    use Rack::SslEnforcer
  end

  set :views, File.expand_path('../../views', __FILE__)
  set :public_dir, File.expand_path('../../public', __FILE__)

  before do
  	if session[:current_user]
      @current_user = SecureMessage.decrypt(session[:current_user])
    end
  end

  get '/' do
    slim :home
  end
end
