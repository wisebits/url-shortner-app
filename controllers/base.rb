require 'sinatra'

# Basic class for UrlShortner Web Application
class UrlShortnerApp < Sinatra::Base
  use Rack::Session::Cookie, code: CookieEncoder.new, let_coder_handle_secure_encoding: true

  set :views, File.expand_path('../../views', __FILE__)

  before do
    @current_user = session[:current_user]
  end

  get '/' do
    slim :home
  end
end
