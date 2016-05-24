require 'sinatra'

# Base class for UrlShortner Web Application
class UrlShortnerApp < Sinatra::Base
  get '/users/:username/projects' do
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
end