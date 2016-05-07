require 'sinatra'

class UrlShortnerApp < Sinatra::Base
  get '/register/?' do
    slim :register
  end

  post '/register/?' do
    begin
      EmailRegistrationVerification.call(
        username: params[:username],
        email: params[:email])
      redirect '/'
    rescue => e
      puts "FAIL EMAIL: #{e}"
      redirect '/register'
    end
  end

  get '/register/:token_secure/verify' do
    @token_secure = params[:token_secure]
    @new_user = SecureMessage.decrypt(@token_secure)

    slim "register_confirm"
  end

  post '/register/:token_secure/verify' do
    redirect "register/#{params[:token_secure]}/verify" unless 
      (params[:password] == params[:password_confirm]) &&
      !params[:password].empty
    
    new_user = SecureMessage.decrypt(params[:token_secure])

    result = CreateVerifiedUser.call(
      username: new_user[:username],
      email: new_user[:email],
      password: params[:password])

    puts "RESULT: #{result}"
    result ? redirect('/login') : redirect('/register')
  end
end