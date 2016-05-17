require 'sinatra'

# Basic class for UrlShortner Web Application
class UrlShortnerApp < Sinatra::Base
  use Rack::Session::Cookie, secret: ENV['MSG_KEY']

  set :views, File.expand_path('../../views', __FILE__)

  before do
    @current_user = session[:current_user]
  end

  get '/' do
    slim :home
  end
end
