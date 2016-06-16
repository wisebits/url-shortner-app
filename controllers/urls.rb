require 'sinatra'
require_relative '../helpers/helper.rb'

# Base class for UrlShortner Web Application
class UrlShortnerApp < Sinatra::Base
  helpers Helpers

  get '/users/:username/urls' do
    if current_user?(params)
      @urls = GetAllUrls.call(current_user: @current_user,
        auth_token: session[:auth_token])
    end

    @urls ? slim(:all_urls) : redirect('/')
  end

  get '/users/:username/urls/:url_id' do
    if current_user?(params)
      @url = GetUrlDetails.call(url_id: params[:url_id],
        auth_token: session[:auth_token])
      if @url
        @statistics = generate_analytics(@url['views'])
        slim(:url)
      else
        flash[:error] = 'We cannot find this url in your account'
        redirect "/users/#{params[:username]}/urls"
      end
    else
      redirect '/login'
    end
  end

  # redirect short_url
  get '/u/*' do
    if @current_user
      # check if url exist by using the short_url
      attribute = params['splat'][0]
      @url = GetUrlDetailsByShorturl.call(shorturl: attribute,
        auth_token: session[:auth_token])
      redirect (@url)
    else
      redirect '/'
    end
  end

  # Add permmission to view for other user
  post '/users/:username/urls/:url_id/viewers/?' do
    halt_if_incorrect_user(params)

    viewer = AddPermissionToUrl.call(
      viewer_email: params[:email],
      url_id: params[:url_id],
      auth_token: session[:auth_token])

    if viewer
      user_info = "#{viewer['username']} (#{viewer['email']})"
      flash[:notice] = "Granted #{user_info} permission to view the url"
    else
      flash[:error] = "Could not give permission to the user with email: #{params['email']}"
    end

    redirect back
  end


  #only logged in user shoule be able to see new url page
  get '/users/:username/new_url' do
   if current_user?(params)
    slim(:new_url)
   else
    redirect '/'
   end
  end
  
  #get url to share
  get 'users/:username/urls/:url_id/share' do
    if current_user?(params)
     @url_id = params[:url_id]
     @url_id ? slim(:share) : redirect('/')
    else
     redirect '/'
    end
  end

  post 'users/:username/urls/:url_id/share' do

  end

  # Create new url
  post '/users/:username/new_url' do

    halt_if_incorrect_user(params)

    urls_url = "/users/#{@current_user['username']}/urls"

    new_url_data = NewUrl.call(params)

    if new_url_data.failure?
      flash[:error] = new_url_data.messages.values.join('; ')
      redirect urls_url
    else
      begin
        new_url = CreateNewUrl.call(
          auth_token: session[:auth_token],
          owner: @current_user,
          new_url: new_url_data.to_h)
        flash[:notice] = "Your URL has been saved! Go ahead and share it!"
        redirect urls_url + "/#{new_url['id']}"
      rescue => e
        flash[:error] = "Oops! Something went wrong!"
        logger.error "New URL FAIL: #{e}"
        redirect "users/#{@current_user['username']}/urls"
      end 
    end
  end
end