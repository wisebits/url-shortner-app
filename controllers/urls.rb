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
    validate_url = NewURL.call(params)
    if validate_url.failure?
      flash[:error] = 'Please ensure you suppy a full URL'
      redirect '/'
      halt
    end


    if @current_user && @current_user['username'] == params[:username]
      new_url = CreateNewUrl.call(
        validate_url,
        auth_token: session[:auth_token],
        current_user: @current_user['id'])

      if new_url
        flash[:notice] = "URL saved successfully"
        redirect '/'
      else
        flash[:error] = 'URL did not save successfully'
        redirect '/'
      end
    end
  end
end