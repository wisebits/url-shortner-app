require 'sinatra'

# User Authentication, Registration, and Authorization
class UrlShortnerApp < Sinatra::Base
  def login_user(authorized_user)
    @current_user = authorized_user['user']
    session[:auth_token] = authorized_user['auth_token']
    session[:current_user] = SecureMessage.encrypt(@current_user)
    flash[:notice] = "Welcome back #{@current_user['username']}"
  end

  # if already logged in should not be seeing login page
  get '/login/?' do
    @gh_url = HTTP.get("#{ENV['API_HOST']}/github_sso_url").parse['url']
    if @current_user
     redirect '/'
    else
     slim(:login)
    end
  end

  post '/login/?' do
    credentials = LoginCredentials.call(params)
    if credentials.failure?
      flash[:error] = 'Please enter both your username and password'
      redirect '/login'
      halt
    end

    auth_user = FindAuthenticatedUser.call(credentials)

    if auth_user
      login_user(auth_user)
      redirect "/users/#{@current_user['username']}/urls"
    else
      flash[:error] = 'Your username or password did not match our records'
      redirect :login
    end
  end

  get '/logout/?' do
    @current_user = nil
    session.clear
    flash[:notice] = 'You have logged out - please login again to use this site'
    redirect :login
  end

  get '/github_callback/?' do
    begin
      sso_user = RetrieveGithubUser.call(params['code'])
      login_user(sso_user)
      redirect "/users/#{@current_user['username']}/urls"
    rescue => e
      flash[:error] = 'Could not sign in using Github'
      puts "RESCUE: #{e}"
      redirect '/login'
    end
  end
end