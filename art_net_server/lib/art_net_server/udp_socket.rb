module ArtNetServer
  module UdpSocket
    def send_message(message)
      connect unless @udp_connected
      @udp_socket.send(message, 0, @udp_host, @udp_port)
    end

    def wait_for_message
      connect unless @udp_connected

      if !@bound
        @udp_socket.bind(@udp_host, @udp_port)
        @bound = true
      end

      output = @udp_socket.recvfrom(@max_packet_size)

      {
        text: output[0],
        sender: output[1]
      }
    end

    def connect(host = 'localhost', port = 1234)
      @udp_host = host
      @udp_port = port
      @max_packet_size = 128

      @udp_socket = UDPSocket.new

      @udp_connected = true
    end
  end
end
