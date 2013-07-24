# run with `bundle exec ruby runner.rb`

require 'art_net_server'

puts "ArtNetServer version: #{ArtNetServer::VERSION}"

thread = Thread.new do
  client = ArtNetServer::Client.new
  client.run
end

server = ArtNetServer::Server.new
5.times do
  server.run
end
server.send_quit_message

thread.join
