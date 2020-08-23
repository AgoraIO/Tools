local ngx = ngx
local require = require
local hmac = require "resty.hmac"
local read_byte_buffer = require "resty.agoradynamickey.read_byte_buffer"
local struct = require "resty.struct"
local bit = require "bit"
local ffi = require "ffi"
local base64_decode = ngx.decode_base64
local base64_encode = ngx.encode_base64
local crc32 = ngx.crc32_long
local now = ngx.now
local pcall = pcall
local sub = string.sub
local concat = table.concat
local tonumber = tonumber
local math = math


math.randomseed(now())
local random = math.random


local nkeys_ok, nkeys = pcall(require, "table.nkeys")
local function len(t)
    if not nkeys_ok then
        return #t
    end

    return nkeys(t)
end


local ok, new_tab = pcall(require, "table.new")
if not ok then
    new_tab = function(narr, nrec)
        return {}
    end
end


local function band(x, y)
    return tonumber(bit.band(ffi.new("uint32_t", x), ffi.new("uint32_t", y)))
end

local function  get_version()
    return "006"
end


local function pack_uint16(x)
    return struct.pack('<H', tonumber(x))
end


local function pack_uint32(x)
    return struct.pack('<I', tonumber(x))
end


local function pack_int32(x)
    return struct.pack('<i', tonumber(x))
end


local function pack_string(s)
    return pack_uint16(#s) .. s
end


local function pack_map(m)
    local ret = pack_uint16(len(m))
    for k, v in pairs(ret) do
        ret = concat({ret, pack_uint16(k), pack_string(v)})
    end
    return ret
end


local function pack_map_uint32(m)
    local ret = pack_uint16(len(m))
    for i=1, len(m) do
        ret = concat({ret, pack_uint16(m[i][1]), pack_uint32(m[i][2])})
    end
    return ret
end


local function unpack_content(buff)
    local read_buff = read_byte_buffer.new(buff)
    local signature = read_buff:unpack_string()
    local crc_channel_name = read_buff:unpack_uint32()
    local crc_uid = read_buff:unpack_uint32()
    local m = read_buff:unpack_string()
    return signature, crc_channel_name, crc_uid, m
end


local function unpack_messages(buff)
    local read_buff = read_byte_buffer.new(buff)
    local salt = read_buff:unpack_uint32()
    local ts = read_buff:unpack_uint32()
    local messages = read_buff:unpack_map_uint32()
    return salt, ts, messages
end


local VERSION_LENGTH = 3
local APP_ID_LENGTH = 32


local _M = {
    kJoinChannel = 1,
    kPublishAudioStream = 2,
    kPublishVideoStream = 3,
    kPublishDataStream = 4,
    kPublishAudiocdn = 5,
    kPublishVideoCdn = 6,
    kRequestPublishAudioStream = 7,
    kRequestPublishVideoStream = 8,
    kRequestPublishDataStream = 9,
    kInvitePublishAudioStream = 10,
    kInvitePublishVideoStream = 11,
    kInvitePublishDataStream = 12,
    kAdministrateChannel = 101,
    kRtmLogin = 1000,
}
local mt = {__index = _M}


function _M.new(app_id, app_certificate, channel_name, uid)
    local uid_str
    if uid == 0 then
        uid_str = ""

    else
        uid_str = tostring(uid)
    end

    local self = {
        app_id = app_id,
        app_certificate = app_certificate,
        channel_name = channel_name,
        ts = now() + 24*3600,
        salt = random(1, 99999999),
        uid_str = uid_str,
        messages = {}
    }
    return setmetatable(self, mt)
end


local function add_privilege(self, privilege, expire_timestamp)
    self.messages[privilege] = expire_timestamp
end


local function from_string(self, origin_token)
    local dk6version = get_version()
    local origin_version = sub(origin_token, 1, VERSION_LENGTH)
    if origin_version ~= dk6version then
        return false, "version not match"
    end

    local origin_app_id = sub(origin_token, VERSION_LENGTH+1, VERSION_LENGTH + APP_ID_LENGTH)
    local origin_content = sub(origin_token, VERSION_LENGTH + 1 + APP_ID_LENGTH)
    local origin_content_decoded = base64_decode(origin_content)
    if origin_content_decoded == nil then
        return false, "b64 decode error"
    end

    local signature, crc_channel_name, crc_uid, m = unpack_content(origin_content_decoded)
    self.salt, self.ts, self.messages = unpack_messages(m)
    return "ok", nil
end


local function order_dict(t, n)
    local new_data = new_tab(n or 5, 0)
    local i = 1
    for k, v in pairs(t) do
        new_data[i] = {k, v}
        i = i + 1
    end
    return new_data
end


local function build(self)
    self.messages = order_dict(self.messages)
    local m = pack_uint32(self.salt) .. pack_uint32(self.ts) .. pack_map_uint32(self.messages)
    local hmac_sha256 = hmac:new(self.app_certificate, hmac.ALGOS.SHA256)
    local val = concat({self.app_id, self.channel_name, self.uid_str, m})
    hmac_sha256:update(val)
    local signature = hmac_sha256:final()
    local crc_channel_name = band(crc32(self.channel_name), 0xffffffff)
    local crc_uid = band(crc32(self.uid_str), 0xffffffff)
    local content = concat({pack_string(signature), pack_uint32(crc_channel_name), pack_uint32(crc_uid), pack_string(m)})
    local version = get_version()
    local ret = concat({version, self.app_id, base64_encode(content)})
    return ret
end


_M.add_privilege = add_privilege
_M.from_string = from_string
_M.build = build

return _M