require 'sinatra'

# Base class for UrlShortner Web Application
class UrlShortnerApp < Sinatra::Base
  get '/users/:username/urls' do
    if @current_user && @current_user['username'] == params[:username]
      @urls = GetAllUrls.call(current_user: @current_user,
        auth_token: session[:auth_token])
    end

    @urls ? slim(:all_urls) :redirect('/login')
  end

  get '/users/:username/urls/:url_id' do
    if @current_user && @current_user['username'] == params[:username]
      @url = GetUrlDetails.call(url_id: params[:url_id],
        auth_token: session[:auth_token])
      if @url
        slim(:url)
      else
        flash[:error] = 'We cannot find this url in your account'
        redirect "/users/#{params[:username]}/urls"
      end
    else
      redirect '/login'
    end
  end

  get '/users/:username/new_url' do
   slim(:new_url) 
  end

  post '/users/:username/new_url' do
    validate_url = NewURL.call(params)
    if validate_url.failure?
      flash[:error] = 'Please ensure you suppy a full URL'
      redirect '/'
      halt
    end

     new_url = CreateNewUrl.call(validate_url)

    
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



    if @current_user && @current_user['username'] == params[:username]
      @url = CreateNewUrl.call(url_id: params[:url_id],
        auth_token: session[:auth_token])
      if @url
        slim(:url)
      else
        flash[:error] = 'We cannot find this url in your account'
        redirect "/users/#{params[:username]}/urls"
      end
    else
      redirect '/login'
    end

    
  end
end