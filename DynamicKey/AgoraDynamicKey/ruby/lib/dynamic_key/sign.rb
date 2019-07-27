# encoding: utf-8

module AgoraDynamicKey
  class Sign
    MAX_SIZE = 1024
    SHA256 = OpenSSL::Digest.new("sha256")
    class InvalidToken < StandardError; end

    class << self
      private def parse_map_uint32 map
        binary = [map.size].pack "v"
        binary << map.flatten.pack("vV"*map.size)
      end

      def encode option
        encode! option
      rescue
        false 
      end

      def encode! option
        # pack message
        message = [option.salt, option.expired_ts].pack "VV" # pack into uint16 with little endian
        message << parse_map_uint32(option.privileges)

        # generate signature
        to_sign = "#{option.app_id}#{option.channel_name}#{option.uid}#{message}"

        sign = OpenSSL::HMAC.new(option.app_certificate, SHA256).update(to_sign).digest

        crc32_channel_name = Zlib::crc32(option.channel_name) & 0xffffffff
        crc32_uid = Zlib::crc32("#{option.uid}") & 0xffffffff

        uint32_channel_name = [crc32_channel_name].pack "V"
        uint32_uid = [crc32_uid].pack "V"

        uint16_sign_size = [sign.size].pack "v"

        uint16_message_size = [message.size].pack "v"
        # generate content
        content = "#{uint16_sign_size}#{sign}#{uint32_channel_name}#{uint32_uid}#{uint16_message_size}#{message}"
        # final content
        "#{AccessToken::VERSION}#{option.app_id}#{Base64.strict_encode64(content)}"
      end

      def decode string
        docode!
      rescue
        false
      end

      def decode! string
        version = string[0..2]
        raise InvalidToken, "can't match version" unless version == VERSION
        appId = string[3..3+31]
        content = string[3+32..-1]
        content_binary = Base64.strict_decode64(content)
        uint16_sign_size = content_binary.unpack("v")[0]
        sign = content_binary[2, uint16_sign_size].unpack "H*"
        offset = uint16_sign_size + 2
        uint32_channel_name, uint32_uid = content_binary[offset..offset+1].unpack("VV")
        offset = offset + 8
        uint16_message_size = content_binary[offset..offset+1].unpack("v")[0]
        offset = offset + 2
        message = content_binary[offset..offset+uint16_message_size]
        salt, expired_ts = message[0..7].unpack("V*")
        privileges_size = message[8..9].unpack("v")[0]
        message[10..-1].unpack("vV"*privileges_size)
        true
      end
    end
  end
end