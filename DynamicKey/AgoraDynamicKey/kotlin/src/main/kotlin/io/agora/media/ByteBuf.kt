package io.agora.media

import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.charset.StandardCharsets
import java.util.*

class ByteBuf {
    var buffer: ByteBuffer = ByteBuffer.allocate(1024).order(ByteOrder.LITTLE_ENDIAN)

    constructor()

    constructor(bytes: ByteArray) {
        buffer = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)
    }

    fun asBytes(): ByteArray {
        val out = ByteArray(buffer.position())
        buffer.rewind()
        buffer.get(out, 0, out.size)
        return out
    }

    fun put(v: Short): ByteBuf {
        ensureCapacity(2)
        buffer.putShort(v)
        return this
    }

    fun put(v: ByteArray): ByteBuf {
        ensureCapacity(2 + v.size)
        put(v.size.toShort())
        buffer.put(v)
        return this
    }

    fun put(v: Int): ByteBuf {
        ensureCapacity(4)
        buffer.putInt(v)
        return this
    }

    fun put(v: Long): ByteBuf {
        ensureCapacity(8)
        buffer.putLong(v)
        return this
    }

    fun put(v: String): ByteBuf {
        return put(v.toByteArray(StandardCharsets.UTF_8))
    }

    fun put(extra: TreeMap<Short, String>): ByteBuf {
        put(extra.size.toShort())
        for ((key, value) in extra) {
            put(key)
            put(value)
        }
        return this
    }

    fun putIntMap(extra: TreeMap<Short, Int>): ByteBuf {
        put(extra.size.toShort())
        for ((key, value) in extra) {
            put(key)
            put(value)
        }
        return this
    }

    fun readShort(): Short {
        return buffer.short
    }

    fun readInt(): Int {
        return buffer.int
    }

    fun readBytes(): ByteArray {
        val length = readShort().toInt()
        val bytes = ByteArray(length)
        buffer.get(bytes)
        return bytes
    }

    fun readString(): String {
        return String(readBytes(), StandardCharsets.UTF_8)
    }

    fun readMap(): TreeMap<Short, String> {
        val map = TreeMap<Short, String>()
        val length = readShort().toInt()
        for (i in 0 until length) {
            val k = readShort()
            val v = readString()
            map[k] = v
        }
        return map
    }

    fun readIntMap(): TreeMap<Short, Int> {
        val map = TreeMap<Short, Int>()
        val length = readShort().toInt()
        for (i in 0 until length) {
            val k = readShort()
            val v = readInt()
            map[k] = v
        }
        return map
    }

    private fun ensureCapacity(capacity: Int) {
        if (buffer.remaining() < capacity) {
            val newCapacity = buffer.capacity() + Math.max(capacity, buffer.capacity())
            val newBuffer = ByteBuffer.allocate(newCapacity).order(ByteOrder.LITTLE_ENDIAN)
            buffer.rewind()
            newBuffer.put(buffer)
            buffer = newBuffer
        }
    }
}
