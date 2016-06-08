Dir.glob('./{config,lib,services,forms,views,controllers}/init.rb').each do |file|
  require file
end

require 'rake/testtask'

namespace :deploy do
  require 'config_env/rake_tasks'
  ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")

  task :config do
    Rake::Task['deploy:config_env:heroku'].invoke
  end
end

task :default => [:spec]

desc 'Run all the tests'
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'specs/*_spec.rb'
end

namespace :key do
  namespace :symmetric do
    require 'rbnacl/libsodium'
    require 'base64'

    desc 'Create 256-bit (32 octets) rbnacl key for encryption'
    task :generate do
      key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
      puts "KEY: #{Base64.strict_encode64 key}"
    end
  end

  namespace :asymmetric do
    require 'jose'

    desc 'Create Ed25519 octet keypair (512 bit secret key) for signing'
    task :generate do
      new_app_secret = JOSE::JWK.generate_key([:okp, :Ed25519])
      new_app_public = new_app_secret.to_public

      saved_secret_key = Base64.strict_encode64(new_app_secret.to_okp[1])
      saved_public_key = Base64.strict_encode64(new_app_public.to_okp[1])

      puts "SECRET KEY: #{saved_secret_key}"
      puts "PUBLIC KEY: #{saved_public_key}"
    end
  end 
end