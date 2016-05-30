require 'sinatra'

class UrlShortnerApp < Sinatra::Base
  get '/register/?' do
    slim :register
  end

  post '/register/?' do
    registration = Registration.call(params)
    if registration.failure?
      flash[:error] = 'Please enter a valid username and email'
      redirect 'register'
      halt
    end

    begin
      EmailRegistrationVerification.call(registration)
      flash[:notice] = 'Please check your email and follow the link to verify your account'
      redirect '/'
    rescue => e
      puts "FAIL EMAIL: #{e}"
      flash[:error] = 'Unable to send email verification -- please '\
                      'check you have entered the right address'
      redirect '/register'
    end
  end

  get '/register/:token_secure/verify' do
    @token_secure = params[:token_secure]
    @new_user = SecureMessage.decrypt(@token_secure)

    slim :register_confirm
  end

  post '/register/:token_secure/verify' do
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

     # add token too??
     if result
      flash[:notice] = "Your account was successfully created! You can now access the service."
      redirect '/login'
    else
      flash[:error] = 'Your account could not be created'
      redirect '/register'
    end
   
    #result ? redirect('/login') : redirect('/register')
  end
end