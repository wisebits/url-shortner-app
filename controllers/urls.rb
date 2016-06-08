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

  #only logged in user shoule be able to see new url page
  get '/users/:username/new_url' do
   if @current_user && @current_user['username'] == params[:username]
    slim(:new_url)
   else
    redirect '/'
   end
  end

  #only logged in user should be able to post a new url
  post '/users/:username/new_url' do

    halt_if_incorrect_user(params)

    urls_url = "/users/#{@current_user['username']}/urls"

    new_url_data = NewUrl.call(params)

    #if @current_user && @current_user['username'] == params[:username]
    if new_url_data.failure?
      flash[:error] = new_url_data.messages.values.join('; ')
      redirect urls_url
    else
      begin
        new_url = CreateNewUrl.call(
          auth_token: session[:auth_token],
          owner: @current_user,
          new_url: new_url_data.to_h)
        flash[:notice] = "Your new url has been created! Now share your url"
        redirect urls_url + "/#{new_url['id']}"
      rescue => e
        flash[:error] = "Oops! Something went wrong!"
        logger.error "New Url FAIL: #{e}"
        redirect "users/#{@current_user['username']}/urls"
      end 
    end
  end
end