Dir.glob('./{config,lib,services,forms,views,controllers}/init.rb').each do |file|
  require file
end

run UrlShortnerApp