require 'sinatra'

# Basic class for UrlShortner Web Application
class UrlShortnerApp < Sinatra::Base
  use Rack::Session::Cookie, expire_after: 2_592_000 # One month in seconds

  set :views, File.expand_path('../../views', __FILE__)

  before do
    @current_account = session[:current_user]
  end

  get '/' do
    slim :home
  end
end
