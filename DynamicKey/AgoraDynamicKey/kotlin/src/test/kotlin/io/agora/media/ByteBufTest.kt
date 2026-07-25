package io.agora.media

import java.util.TreeMap
import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** Tests Token007 primitive packing and dynamic buffer growth. */
class ByteBufTest {
    /** Round-trips primitive values, strings, byte arrays, and ordered maps. */
    @Test
    fun roundTripsPackedValues() {
        val strings = TreeMap<Short, String>().apply {
            put(2, "second")
            put(1, "first")
        }
        val privileges = TreeMap<Short, Int>().apply {
            put(2, 200)
            put(1, 100)
        }
        val packed = ByteBuf()
            .put(7.toShort())
            .put(42)
            .put(43L)
            .put("value")
            .put(byteArrayOf(1, 2, 3))
            .put(strings)
            .putIntMap(privileges)
            .asBytes()

        val parser = ByteBuf(packed)
        assertEquals(7.toShort(), parser.readShort())
        assertEquals(42, parser.readInt())
        assertEquals(43L, parser.buffer.long)
        assertEquals("value", parser.readString())
        assertArrayEquals(byteArrayOf(1, 2, 3), parser.readBytes())
        assertEquals(strings, parser.readMap())
        assertEquals(privileges, parser.readIntMap())
    }

    /** Grows beyond the initial capacity without changing packed bytes. */
    @Test
    fun growsForLargePayloads() {
        val payload = ByteArray(4096) { (it and 0xff).toByte() }
        val packed = ByteBuf().copy(payload).asBytes()

        assertTrue(packed.size > 1024)
        assertArrayEquals(payload, packed)
    }

    /** Exercises the generic service privilege unpacking implementation. */
    @Test
    fun unpacksGenericServicePrivileges() {
        val privileges = TreeMap<Short, Int>().apply { put(1, 600) }
        val service = AccessToken2.Service(999)

        val packed = ByteBuf().putIntMap(privileges).asBytes()
        service.unpack(ByteBuf(packed))

        assertEquals(privileges, service.privileges)
    }
}
