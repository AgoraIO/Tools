package io.agora.media

import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.charset.StandardCharsets
import java.util.TreeMap

/** Packs and unpacks Token007 values using little-endian byte order. */
class ByteBuf {
    internal var buffer: ByteBuffer = ByteBuffer.allocate(INITIAL_CAPACITY).order(ByteOrder.LITTLE_ENDIAN)

    /** Creates an empty byte buffer for packing values. */
    constructor()

    /** Wraps existing bytes for unpacking values. */
    constructor(bytes: ByteArray) {
        buffer = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)
    }

    /** Returns the packed bytes written to this buffer. */
    fun asBytes(): ByteArray {
        val duplicate = buffer.duplicate()
        duplicate.flip()
        return ByteArray(duplicate.remaining()).also(duplicate::get)
    }

    /** Packs an unsigned 16-bit protocol value represented by a Kotlin Short. */
    fun put(value: Short): ByteBuf {
        ensureCapacity(Short.SIZE_BYTES)
        buffer.putShort(value)
        return this
    }

    /** Packs a length-prefixed byte array. */
    fun put(value: ByteArray): ByteBuf {
        put(value.size.toShort())
        ensureCapacity(value.size)
        buffer.put(value)
        return this
    }

    /** Appends bytes without a length prefix. */
    fun copy(value: ByteArray): ByteBuf {
        ensureCapacity(value.size)
        buffer.put(value)
        return this
    }

    /** Packs an unsigned 32-bit protocol value represented by a Kotlin Int. */
    fun put(value: Int): ByteBuf {
        ensureCapacity(Int.SIZE_BYTES)
        buffer.putInt(value)
        return this
    }

    /** Packs a 64-bit integer. */
    fun put(value: Long): ByteBuf {
        ensureCapacity(Long.SIZE_BYTES)
        buffer.putLong(value)
        return this
    }

    /** Packs a length-prefixed UTF-8 string. */
    fun put(value: String): ByteBuf = put(value.toByteArray(StandardCharsets.UTF_8))

    /** Packs a map of short keys and string values in numeric key order. */
    fun put(values: TreeMap<Short, String>): ByteBuf {
        put(values.size.toShort())
        values.forEach { (key, value) -> put(key).put(value) }
        return this
    }

    /** Packs a map of privilege identifiers and expiration timestamps. */
    fun putIntMap(values: TreeMap<Short, Int>): ByteBuf {
        put(values.size.toShort())
        values.forEach { (key, value) -> put(key).put(value) }
        return this
    }

    /** Reads a 16-bit protocol value. */
    fun readShort(): Short = buffer.short

    /** Reads a 32-bit protocol value. */
    fun readInt(): Int = buffer.int

    /** Reads a length-prefixed byte array. */
    fun readBytes(): ByteArray {
        val length = readShort().toInt() and 0xffff
        return ByteArray(length).also(buffer::get)
    }

    /** Reads a length-prefixed UTF-8 string. */
    fun readString(): String = String(readBytes(), StandardCharsets.UTF_8)

    /** Reads a map of short keys and string values. */
    fun readMap(): TreeMap<Short, String> {
        val result = TreeMap<Short, String>()
        repeat(readShort().toInt() and 0xffff) {
            result[readShort()] = readString()
        }
        return result
    }

    /** Reads a map of privilege identifiers and expiration timestamps. */
    fun readIntMap(): TreeMap<Short, Int> {
        val result = TreeMap<Short, Int>()
        repeat(readShort().toInt() and 0xffff) {
            result[readShort()] = readInt()
        }
        return result
    }

    /** Grows the packing buffer when the next value does not fit. */
    private fun ensureCapacity(additionalLength: Int) {
        val requiredLength = buffer.position() + additionalLength
        if (requiredLength <= buffer.capacity()) {
            return
        }

        var newCapacity = buffer.capacity()
        while (newCapacity < requiredLength) {
            newCapacity *= 2
        }
        val expanded = ByteBuffer.allocate(newCapacity).order(ByteOrder.LITTLE_ENDIAN)
        buffer.flip()
        expanded.put(buffer)
        buffer = expanded
    }

    private companion object {
        const val INITIAL_CAPACITY = 1024
    }
}
