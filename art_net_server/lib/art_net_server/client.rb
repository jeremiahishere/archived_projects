require 'socket'

module ArtNetServer
  class Client
    include UdpSocket

    def initialize
    end

    def run
      loop do
        message = wait_for_message
        puts "#{message[:text]} sent by #{message[:sender]}"

        break if message[:text] == 'quit'
      end
    end
  end
end
