local base64 = require("base64")
local hmac = require("openssl.hmac")
local md5 = require("md5")
local zlib = require("zlib")

local function base64_encode_str(data)
    return base64.encode(data)
end

local function base64_decode_str(data)
    return base64.decode(data)
end

local function compress_zlib(data)
    local deflate = zlib.deflate()
    local compressed_data, eof, bytes_in, bytes_out = deflate(data, "finish")
    return compressed_data
end

local function count_table_elements(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

local function decompress_zlib(data)
    local inflate = zlib.inflate()
    local decompressed_data, eof, bytes_in, bytes_out = inflate(data, "finish")
    return decompressed_data
end

local function format_map(map)
    local result = {}
    for k, v in pairs(map) do
        table.insert(result, string.format("%s=%s", k, v))
    end
    return table.concat(result, ", ")
end

local function get_rand(min, max)
    if max <= min then
        return min
    end

    math.randomseed(os.time())

    return math.random(min, max)
end

local function hmac_sha256(key, data)
    local hmac_sha256 = hmac.new(key, "sha256")
    local digest = hmac_sha256:final(data)

    return digest
end

local function md5_hash(data)
    return md5.sumhexa(data)
end

local function print_table(t, indent)
    indent = indent or ""

    for key, value in pairs(t) do
        io.write(indent .. tostring(key) .. ": ")

        if type(value) == "table" then
            print()
            print_table(value, indent .. "  ")
        else
            print(tostring(value))
        end
    end
end

local function to_hex(data)
    return (data:gsub('.', function(c)
        return string.format('%02x', string.byte(c))
    end))
end

local function pack_int16(x)
    return string.pack("<h", x)
end

local function unpack_int16(data)
    local x, offset = string.unpack("<h", data)
    return x, string.sub(data, offset, string.len(data))
end

local function pack_uint16(x)
    return string.pack("<I2", x)
end

local function unpack_uint16(data)
    local x, offset = string.unpack("<I2", data)
    return x, string.sub(data, offset, string.len(data))
end

local function pack_uint32(x)
    return string.pack("<I4", x)
end

local function unpack_uint32(data)
    local x, offset = string.unpack("<I4", data)
    return x, string.sub(data, offset, string.len(data))
end

local function pack_string(str)
    return pack_uint16(#str) .. str
end

local function unpack_string(data)
    local len, rest = unpack_uint16(data)
    local str = rest:sub(1, len)
    rest = rest:sub(len + 1)
    return str, rest
end

local function pack_map_uint32(arr)
    local keys = {}
    for k in pairs(arr) do
        table.insert(keys, k)
    end
    table.sort(keys)

    local kv = ""
    for _, key in ipairs(keys) do
        kv = kv .. pack_uint16(key) .. pack_uint32(arr[key])
    end

    return pack_uint16(#keys) .. kv
end

local function unpack_map_uint32(data)
    local len, rest = unpack_uint16(data)
    local arr = {}

    for i = 1, len do
        local key, rest1 = unpack_uint16(rest)
        local val, rest2 = unpack_uint32(rest1)
        arr[key] = val
        rest = rest2
    end

    return arr, rest
end

return {
    base64_encode_str = base64_encode_str,
    base64_decode_str = base64_decode_str,
    compress_zlib = compress_zlib,
    count_table_elements = count_table_elements,
    decompress_zlib = decompress_zlib,
    format_map = format_map,
    get_rand = get_rand,
    hmac_sha256 = hmac_sha256,
    md5_hash = md5_hash,
    pack_map_uint32 = pack_map_uint32,
    pack_int16 = pack_int16,
    pack_string = pack_string,
    pack_uint16 = pack_uint16,
    pack_uint32 = pack_uint32,
    print_table = print_table,
    to_hex = to_hex,
    unpack_map_uint32 = unpack_map_uint32,
    unpack_int16 = unpack_int16,
    unpack_string = unpack_string,
    unpack_uint16 = unpack_uint16,
    unpack_uint32 = unpack_uint32,
}
