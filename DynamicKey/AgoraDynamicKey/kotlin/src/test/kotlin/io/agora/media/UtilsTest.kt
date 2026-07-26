package io.agora.media

import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/** Tests cryptographic, encoding, compression, and validation helpers. */
class UtilsTest {
    /** Verifies digest, HMAC, Base64, CRC32, and UUID helpers. */
    @Test
    fun cryptographicAndEncodingHelpers() {
        val data = "hello".toByteArray()

        assertEquals("5d41402abc4b2a76b9719d911017c592", Utils.md5("hello"))
        assertEquals(32, Utils.hmacSign("key", data).size)
        assertArrayEquals(data, Utils.base64Decode(Utils.base64Encode(data)))
        assertEquals(Utils.crc32("hello"), Utils.crc32(data))
        assertTrue(Utils.isUUID("970CA35de60c44645bbae8a215061b33"))
        assertFalse(Utils.isUUID(null))
        assertFalse(Utils.isUUID("invalid"))
    }

    /** Verifies compression round trips and malformed data handling. */
    @Test
    fun compressionHelpers() {
        val data = "hello Token007".toByteArray()

        assertArrayEquals(data, Utils.decompress(Utils.compress(data)))
        assertArrayEquals(ByteArray(0), Utils.decompress(byteArrayOf(1, 2, 3)))
    }

    /** Verifies timestamp and random helpers return usable values. */
    @Test
    fun timeAndRandomHelpers() {
        assertTrue(Utils.getTimestamp() > 0)
        assertTrue(Utils.randomInt() in Int.MIN_VALUE..Int.MAX_VALUE)
    }
}
