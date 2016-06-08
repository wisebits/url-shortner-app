require 'sinatra'
require 'rack-flash'
require 'rack/ssl-enforcer'

# Basic class for UrlShortner Web Application
class UrlShortnerApp < Sinatra::Base
  enable :logging
  use Rack::Flash

  set :views, File.expand_path('../../views', __FILE__)
  set :public_dir, File.expand_path('../../public', __FILE__)

  before do
    if session[:current_user]
      @current_user = SecureMessage.decrypt(session[:current_user])
    end
  end

  def current_user?(params)
    @current_user && @current_user['username'] == params[:username]
  end

  def halt_if_incorrect_user(params)
    return true if current_user?(params)
    flash[:error] = 'You used the wrong account for this request'
    redirect '/login'
    halt
  end

  get '/' do
    slim :home
  end
end
