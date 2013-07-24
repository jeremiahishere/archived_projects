require 'socket'

module ArtNetServer
  class Server
    include UdpSocket

    def initialize
      @counter = 0
    end

    def run
      @counter += 1
      send_message("hello #{@counter}")
    end

    def send_quit_message
      send_message('quit')
    end
  end
end
