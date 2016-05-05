require 'sinatra'

# Base class for Url Shortner Web Application
class UrlShortnerApp < Sinatra::Base
  get '/login/?' do
    slim :login
  end

  post '/login/?' do
    username = params[:username]
    password = params[:password]

    @current_user = FindAuthenticatedUser.call(
      username: username, password: password)

    if @current_user
      session[:current_user] = @current_user
      slim :home
    else
      slim :login
    end
  end

  get '/logout/?' do
    @current_user = nil
    session[:current_user] = nil
    slim :login
  end

  get '/user/:username' do
    if @current_user && @current_user['username'] == params[:username]
      slim(:user)
    else
      slim(:login)
    end
  end

  get '/register/?' do
    slim(:register)
  end

  post '/register' do
    username = params[:username]
    email = params[:email]
    password = params[:password]
    password_confirm = params[:password_confirm]

    #check password here

    @new_user = RegisterNewUser.call(
      username: username, email: email, password: password)

    #puts @new_user

    #if password == password_confirm
      if @new_user
        session[:current_user] = @new_user 
        slim :home
      else
        slim :register
      end
    #else
      #slim :register # show message to user too
    #end
  end
end
