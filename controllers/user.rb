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

    auth_user = FindAuthenticatedUser.call(credentials)
    puts ENV['API_HOST']
    puts 'auth_user: '
    puts auth_user

    
    if auth_user
      @current_user = auth_user['user']
      session[:auth_token] = auth_user['auth_token']
      session[:current_user] = SecureMessage.encrypt(@current_user)
      flash[:notice] = "Welcome, #{@current_user['username']}!"
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
end