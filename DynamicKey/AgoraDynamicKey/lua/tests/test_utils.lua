local luaunit = require("luaunit")
local utils = require("agora_token.utils")

-- Verifies Base64 encoding and decoding.
function test_base64_encode_str()
    local encode_str = utils.base64_encode_str("hello")
    luaunit.assertEquals(encode_str, "aGVsbG8=")
    local decode_str = utils.base64_decode_str(encode_str)
    luaunit.assertEquals(decode_str, "hello")
end

-- Verifies zlib compression and decompression.
function test_compress_zlib()
    local compressed = utils.compress_zlib("hello")
    luaunit.assertEquals(utils.base64_encode_str(compressed), "eJzLSM3JyQcABiwCFQ==")
    luaunit.assertEquals(utils.decompress_zlib(compressed), "hello")
end

-- Verifies unsigned 16-bit integer packing.
function test_pack_uint16()
    local data = utils.pack_uint16(600)
    luaunit.assertEquals(utils.base64_encode_str(data), "WAI=")

    local i = utils.unpack_uint16(data)
    luaunit.assertEquals(i, 600)
end

-- Verifies unsigned 32-bit integer packing.
function test_pack_uint32()
    local data = utils.pack_uint32(600)
    luaunit.assertEquals(utils.base64_encode_str(data), "WAIAAA==")

    local i = utils.unpack_uint32(data)
    luaunit.assertEquals(i, 600)
end

-- Verifies signed 16-bit integer packing.
function test_pack_int16()
    local data = utils.pack_int16(-1)
    local i = utils.unpack_int16(data)
    luaunit.assertEquals(i, -1)
end

-- Verifies length-prefixed string packing.
function test_pack_string()
    local data = utils.pack_string("hello")
    luaunit.assertEquals(utils.base64_encode_str(data), "BQBoZWxsbw==")

    local s = utils.unpack_string(data)
    luaunit.assertEquals(s, "hello")
end

-- Verifies stable map packing and unpacking.
function test_pack_map_uint32()
    local data = utils.pack_map_uint32({ [1] = 2, [3] = 4 })
    luaunit.assertEquals(utils.base64_encode_str(data), "AgABAAIAAAADAAQAAAA=")

    local m = utils.unpack_map_uint32(data)
    luaunit.assertEquals(m[1], 2)
    luaunit.assertEquals(m[3], 4)
    luaunit.assertEquals(utils.format_map(m), "1=2, 3=4")
end

-- Verifies table counting and random-number boundary handling.
function test_table_count_and_random_boundaries()
    luaunit.assertEquals(2, utils.count_table_elements({ first = 1, second = 2 }))
    luaunit.assertEquals(5, utils.get_rand(5, 5))
    local random = utils.get_rand(1, 2)
    luaunit.assertTrue(random >= 1 and random <= 2)
end

-- Verifies digest and binary-to-hex helpers.
function test_digest_helpers()
    luaunit.assertEquals("5d41402abc4b2a76b9719d911017c592", utils.md5_hash("hello"))
    luaunit.assertEquals("6869", utils.to_hex("hi"))
    luaunit.assertEquals(
        "5031fe3d989c6d1537a013fa6e739da23463fdaec3b70137d828e36ace221bd0",
        utils.to_hex(utils.hmac_sha256("key", "data"))
    )
end

os.exit(luaunit.LuaUnit.run())
