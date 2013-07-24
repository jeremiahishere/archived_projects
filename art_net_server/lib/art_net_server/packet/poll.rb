module ArtNetServer
  module Packet
    # full packet definition http://art-net.org.uk/?page_id=575
    #
    # Byte Offset Name      Size  Brief Description
    # 0           ID[]      8     String which Identifies this as Art-Net
    # 8           OpCodeLo  1     Defines this packet type
    # 9           OpCodeHi  1     Defines this packet type
    # 10          ProtVerHi 1     Protocol Version
    # 11          ProtVerLo 1     Protocol Version
    # 12          TalkToMe  1     Configuration bits
    # 13          Priority  1     Diagnostics priority
    class Poll < Base
      attr_reader :talk_to_me, :priority

      def self.opcode
        0x2000
      end

      def initialize
        @talk_to_me = 0
        @priority = 0
      end

      def pack
        # packet includes two unsigned char bytes
        build_packet([
          { value: talk_to_me, format: 'C' },
          { value: priority, format: 'C' }
        ])
      end

      def unpack
      end
    end
  end
end
