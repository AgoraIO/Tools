require 'base64'

module AgoraDynamicKey2
  class Util
    def self.pack_int16(int)
      [int].pack('s')
    end

    def self.unpack_int16(data)
      [data[0..2].unpack1('s'), data[2..-1]]
    end

    def self.pack_uint16(int)
      [int].pack('v')
    end

    def self.unpack_uint16(data)
      [data[0..2].unpack1('v'), data[2..-1]]
    end

    def self.pack_uint32(int)
      [int].pack('V')
    end

    def self.unpack_uint32(data)
      [data[0..4].unpack1('V'), data[4..-1]]
    end

    def self.pack_string(str)
      pack_uint16(str.bytesize) + str
    end

    def self.unpack_string(data)
      len, data = unpack_uint16(data)
      if len.zero?
        return ['', data[len..-1]]
      end
      [data[0..len - 1], data[len..-1]]
    end

    def self.pack_map_uint32(map)
      kv = ''
      Hash[map.sort].each do |k, v|
        kv += pack_uint16(k) + pack_uint32(v)
      end
      (pack_uint16(map.size) + kv).force_encoding('utf-8')
    end

    def self.unpack_map_uint32(data)
      len, data = unpack_uint16(data)
      map = {}
      (1..len).each do
        k, data = unpack_uint16(data)
        v, data = unpack_uint32(data)
        map[k] = v
      end
      [map, data]
    end
  end
end

