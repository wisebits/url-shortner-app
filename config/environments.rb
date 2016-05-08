require 'sinatra'
require 'pony'

configure :development, :test do
  require 'config_env'
  ConfigEnv.path_to_config("#{__dir__}/config_env.rb")
end

configure do
  enable :logging

  Pony.options = {
    from: "noreply@#{ENV['SENDGRID_DOMAIN']}",
    via: :smtp,
    via_options: {
      address: 'smtp.sendgrid.net',
      port: '587',
      domain: ENV['SENDGRID_DOMAIN'],
      user_name: ENV['SENDGRID_USERNAME'],
      password: ENV['SENDGRID_PASSWORD'],
      authentication: :plain,
      enable_starttls_auto: true
    }
  }
end