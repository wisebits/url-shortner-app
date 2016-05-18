require 'sinatra'

# Base class for Url Shortner Web Application
class UrlShortnerApp < Sinatra::Base
  get '/login/?' do
    slim :login
  end

  post '/login/?' do
    credentials = LoginCredentials.call(params)
    if credentials.failure?
      flash[:error] = 'Please enter both your username and password'
      redirect '/login'
      halt
    end

    @current_user = FindAuthenticatedUser.call(credentials)

    if @current_user
      session[:current_user] = SecureMessage.encrypt(@current_user)
      flash[:notice] = "Welcome back #{@current_user['username']}!"
      redirect '/'
    else
      flash[:error] = 'Your username or password did not match our records.'
      slim :login
    end
  end

  get '/logout/?' do
    @current_user = nil
    session[:current_user] = nil
    flash[:notice] = 'You have logged out. Please login again to use this site.'
    slim :login
  end

  get '/user/:username' do
    if @current_user && @current_user['username'] == params[:username]
      slim(:user)
    else
      slim(:login)
    end
  end
end