# -*- coding: utf-8 -*-
__copyright__ = "Copyright (c) 2014-2017 Agora.io, Inc."

import struct


def pack_uint16(x):
    """Pack a value as a little-endian unsigned 16-bit integer."""
    return struct.pack('<H', int(x))


def unpack_uint16(buffer):
    """Unpack a little-endian uint16 and return it with the remaining buffer."""
    data_length = struct.calcsize('H')
    return struct.unpack('<H', buffer[:data_length])[0], buffer[data_length:]


def pack_uint32(x):
    """Pack a value as a little-endian unsigned 32-bit integer."""
    return struct.pack('<I', int(x))


def unpack_uint32(buffer):
    """Unpack a little-endian uint32 and return it with the remaining buffer."""
    data_length = struct.calcsize('I')
    return struct.unpack('<I', buffer[:data_length])[0], buffer[data_length:]


def pack_int16(x):
    """Pack a value as a little-endian signed 16-bit integer."""
    return struct.pack('<h', int(x))


def unpack_int16(buffer):
    """Unpack a little-endian int16 and return it with the remaining buffer."""
    data_length = struct.calcsize('h')
    return struct.unpack('<h', buffer[:data_length])[0], buffer[data_length:]


def pack_string(string):
    """Pack bytes with an unsigned 16-bit length prefix."""
    # if isinstance(string, str):
    #     string = string.encode('utf-8')
    return pack_uint16(len(string)) + string


def unpack_string(buffer):
    """Unpack length-prefixed bytes and return them with the remaining buffer."""
    data_length, buffer = unpack_uint16(buffer)
    return struct.unpack('<{}s'.format(data_length), buffer[:data_length])[0], buffer[data_length:]


def pack_map_uint32(m):
    """Pack a uint16-to-uint32 map with an unsigned 16-bit entry count."""
    return pack_uint16(len(m)) + b''.join([pack_uint16(k) + pack_uint32(v) for k, v in m.items()])


def unpack_map_uint32(buffer):
    """Unpack a uint16-to-uint32 map and return it with the remaining buffer."""
    data_length, buffer = unpack_uint16(buffer)

    data = {}
    for i in range(data_length):
        k, buffer = unpack_uint16(buffer)
        v, buffer = unpack_uint32(buffer)
        data[k] = v
    return data, buffer


def pack_map_string(m):
    """Pack a uint16-to-bytes map with an unsigned 16-bit entry count."""
    return pack_uint16(len(m)) + b''.join([pack_uint16(k) + pack_string(v) for k, v in m.items()])


def unpack_map_string(buffer):
    """Unpack a uint16-to-bytes map and return it with the remaining buffer."""
    data_length, buffer = unpack_uint16(buffer)

    data = {}
    for i in range(data_length):
        k, buffer = unpack_uint16(buffer)
        v, buffer = unpack_string(buffer)
        data[k] = v
    return data, buffer
