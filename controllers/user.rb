require 'sinatra'

# Base class for Url Shortner Web Application
class UrlShortnerApp < Sinatra::Base
  get '/users/:username' do
    halt_if_incorrect_user(params)

    @auth_token = session[:auth_token]
    slim(:user)
  end
end
