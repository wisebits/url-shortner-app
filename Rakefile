Dir.glob('./{config,lib,services,views,controllers}/init.rb').each do |file|
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
  require 'rbnacl/libsodium'
  require 'base64'

  desc 'Create rbnacl key'
  task :generate do
    key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
    puts "KEY: #{Base64.strict_encode64 key}"
  end
end