require 'base64'

module AgoraDynamicKey2
  # Serializes and deserializes Token007 primitive values.
  class Util
    # Packs a signed 16-bit integer in little-endian order.
    def self.pack_int16(int)
      [int].pack('s<')
    end

    # Unpacks a signed 16-bit little-endian integer.
    def self.unpack_int16(data)
      [data.byteslice(0, 2).unpack1('s<'), data.byteslice(2..)]
    end

    # Packs an unsigned 16-bit integer in little-endian order.
    def self.pack_uint16(int)
      [int].pack('v')
    end

    # Unpacks an unsigned 16-bit little-endian integer.
    def self.unpack_uint16(data)
      [data.byteslice(0, 2).unpack1('v'), data.byteslice(2..)]
    end

    # Packs an unsigned 32-bit integer in little-endian order.
    def self.pack_uint32(int)
      [int].pack('V')
    end

    # Unpacks an unsigned 32-bit little-endian integer.
    def self.unpack_uint32(data)
      [data.byteslice(0, 4).unpack1('V'), data.byteslice(4..)]
    end

    # Packs a length-prefixed byte string.
    def self.pack_string(str)
      bytes = str.to_s.b
      pack_uint16(bytes.bytesize) + bytes
    end

    # Unpacks a length-prefixed byte string.
    def self.unpack_string(data)
      len, data = unpack_uint16(data)
      raise ArgumentError, 'invalid packed string length' if data.nil? || data.bytesize < len

      [data.byteslice(0, len), data.byteslice(len..)]
    end

    # Packs an unsigned privilege map in numeric key order.
    def self.pack_map_uint32(map)
      kv = ''.b
      Hash[map.sort].each do |k, v|
        kv += pack_uint16(k) + pack_uint32(v)
      end
      pack_uint16(map.size) + kv
    end

    # Unpacks an unsigned privilege map.
    def self.unpack_map_uint32(data)
      len, data = unpack_uint16(data)
      map = {}
      len.times do
        k, data = unpack_uint16(data)
        v, data = unpack_uint32(data)
        map[k] = v
      end
      [map, data]
    end
  end
end
