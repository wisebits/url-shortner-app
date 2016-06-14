Dir.glob('./{config,lib,services,helpers,forms,views,controllers}/init.rb').each do |file|
  require file
end

run UrlShortnerApp