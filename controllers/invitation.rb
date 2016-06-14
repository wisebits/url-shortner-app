require 'sinatra'

class UrlShortnerApp < Sinatra::Base
  get '/invitation/:token_secure/accept' do
    @token_secure = params[:token_secure]
    @new_user = SecureMessage.decrypt(@token_secure)

    #check if user exists based on email, add service to check if user exists based on email
    # if exists no need to create a new account, just add permission
    # if don't exist, add user account and add permission for url
    # can also check if url already accessible by user before even sending email


    slim :register_confirm
  end

  post '/invitation/:token_secure/accept' do
    passwords = Passwords.call(params)
    if passwords.failure?
      flash[:error] = passwords.messages.values.join('; ')
      redirect "/register/#{params[:token_secure]}/verify"
      halt
    end

    new_user = SecureMessage.decrypt(params[:token_secure])  

    result = CreateVerifiedUser.call(
      username: new_user['username'],
      email: new_user['email'],
      password: passwords[:password])

     if result
      flash[:notice] = "Your account was successfully created! You can now access the service."
      redirect '/login'
    else
      flash[:error] = 'Your account could not be created'
      redirect '/register'
    end
    #unless result
     # flash[:error] = "Oops! Something went wrong! Please try registering again"
    #end
   # result ? redirect('/login') : redirect('/register')
  end
end