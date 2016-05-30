require 'sinatra'

# Base class for Url Shortner Web Application
class UrlShortnerApp < Sinatra::Base
  get '/users/:username' do
    if @current_user && @current_user['username'] == params[:username]
      @auth_token = session[:auth_token]
      slim(:user)
    else
      slim(:login)
    end
  end
end