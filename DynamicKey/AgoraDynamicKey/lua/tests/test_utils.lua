local luaunit = require('luaunit')
local utils = require('agora_token.utils')

function test_base64_encode_str()
    local encode_str = utils.base64_encode_str("hello")
    luaunit.assertEquals(encode_str, "aGVsbG8=")
    local decode_str = utils.base64_decode_str(encode_str)
    luaunit.assertEquals(decode_str, "hello")
end

function test_compress_zlib()
    local compressed = utils.compress_zlib("hello")
    luaunit.assertEquals(utils.base64_encode_str(compressed), "eJzLSM3JyQcABiwCFQ==")
    luaunit.assertEquals(utils.decompress_zlib(compressed), "hello")
end

function test_pack_uint16()
    data = utils.pack_uint16(600)
    luaunit.assertEquals(utils.base64_encode_str(data), "WAI=")

    local i = utils.unpack_uint16(data)
    luaunit.assertEquals(i, 600)
end

function test_pack_uint32()
    data = utils.pack_uint32(600)
    luaunit.assertEquals(utils.base64_encode_str(data), "WAIAAA==")

    local i = utils.unpack_uint32(data)
    luaunit.assertEquals(i, 600)
end

function test_pack_int16()
    data = utils.pack_int16(-1)
    local i = utils.unpack_int16(data)
    luaunit.assertEquals(i, -1)
end

function test_pack_string()
    data = utils.pack_string("hello")
    luaunit.assertEquals(utils.base64_encode_str(data), "BQBoZWxsbw==")

    local s = utils.unpack_string(data)
    luaunit.assertEquals(s, "hello")
end

function test_pack_map_uint32()
    data = utils.pack_map_uint32({ [1] = 2, [3] = 4 })
    luaunit.assertEquals(utils.base64_encode_str(data), "AgABAAIAAAADAAQAAAA=")

    local m = utils.unpack_map_uint32(data)
    luaunit.assertEquals(m[1], 2)
    luaunit.assertEquals(m[3], 4)
    luaunit.assertEquals(utils.format_map(m), "1=2, 3=4")
end

os.exit(luaunit.LuaUnit.run())
