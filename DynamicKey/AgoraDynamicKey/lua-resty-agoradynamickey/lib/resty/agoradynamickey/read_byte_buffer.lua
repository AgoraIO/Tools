-- local struct = require "resty.struct"
local require = require
local struct = require "resty.struct"
local ffi = require "ffi"
local sub = string.sub
local setmetatable = setmetatable

local _M = {}
local mt = {__index = _M}


function _M.new(buffer)
    local self = {
        buffer = buffer,
        position = 1
    }
    return setmetatable(self, mt)
end


local function unpack_uint16(self)
    local len = ffi.sizeof("unsigned short")
    local buff = sub(self.buffer, self.position, self.position+len-1)
    local ret = struct.unpack('<H', buff)
    self.position = self.position + len
    return ret
end


local function unpack_uint32(self)
    local len = ffi.sizeof("unsigned int")
    local buff = sub(self.buffer, self.position, self.position+len-1)
    local ret = struct.unpack('<I', buff)
    self.position = self.position + len
    return ret
end


local function  unpack_string(self)
    local str_len = self:unpack_uint16()
    local buff = sub(self.buffer, self.position, self.position+str_len-1)
    local ret = struct.unpack('<'..str_len..'s', buff)
    self.position = self.position + str_len
    return ret
end


local function unpack_map_uint32(self)
    local messages = {}
    local map_len = self:unpack_uint16()
    local key
    local value
    for i=1, map_len do
        key = self:unpack_uint16()
        value = self:unpack_uint32()
        messages[key] = value
    end

    return messages
end


_M.unpack_uint16 = unpack_uint16
_M.unpack_uint32 = unpack_uint32
_M.unpack_string = unpack_string
_M.unpack_map_uint32 = unpack_map_uint32

return _M