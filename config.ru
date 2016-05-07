Dir.glob('./{config,lib,services,views,controllers}/init.rb').each do |file|
  require file
end

run UrlShortnerApp