module ArtNetServer
  module Packet
    # more art-net docs https://en.wikipedia.org/wiki/Art-Net
    class Base

      # protocol id: arbitrary binary string, space padded with * for null, 7 characters long and a null eighth byte
      def self.packet_id_compoment
        { name: 'packet_id', value: 'Art-Net', format: 'Z7x' }
      end

      # protocol version: 16 bit unsigned big endian byte order
      def self.protocol_version_component
        { name: 'protocol_version', value: 14, format: 'v' }
      end

      # opcode: 16 bit unsigned little endian byte order
      def self.opcode_component
        { name: 'opcode', value: self.opcode, format: 'n' }
      end

      def self.opcode
        raise NotImplementedError.new('the base packet does not have an opcode')
      end

      def self.prefix_components
        [protocol_id_component, opcode_component, protocol_version_component]
      end

      # factory method to create new packet instances based on the opcode set in the types method
      # complex enough to move to it's own class probably
      # need to clean up validations a bit
      #
      def self.load(data)
        unpacked_data = data.unpack(component_format(self.prefix_components))  

        packet_id_index = 0
        opcode_index = 1
        protocol_version_index = 2

        if unpacked_data[packet_id_index] != packet_id 
          raise Exception.new("Packet id does not match expected value, #{packet_id}")
        end
        if unpacked_data[protocol_version_index] != protocol_id
          raise Exception.new("Packet id does not match expected value, #{protocol_id}")
        end
        if !types.has_key?(unpacked_data[opcode_index])
          raise Exception.new("Unknown opcode found")
        end

        types[unpacked_data[opcode_index]].new.unpack(data)
      end

      def self.types
        {}.tap do |types|
          [Poll].each do |klass|
            types[klass.opcode] = klass
          end
        end
      end

      def build_packet(data, format)
        full_components = self.class.prefix_components + components
        data = component_data(full_components)
        format = component_format(full_components)
        puts "Building a packet for the data: '#{data}' with the format: '#{format}'"

        data.pack(format)
      end

      # this component management code almost certainly belongs in another class
      def component_format(components)
        components.collect { |c| c[:format] }.join('')
      end

      def component_data(components)
        components.collect { |c| c[:value] }
      end

      # https://ruby-doc.org/core-2.2.0/Array.html#method-i-pack
      def pack
        raise NotImplementedError
      end

      def unpack
        raise NotImplementedError
      end
    end
  end
end
