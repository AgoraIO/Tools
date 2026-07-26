package io.agora.media;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.Map;
import java.util.TreeMap;

/**
 * Packs and unpacks Token007 values using little-endian byte order.
 */
public class ByteBuf {
    private static final int INITIAL_CAPACITY = 1024;
    ByteBuffer buffer = ByteBuffer.allocate(INITIAL_CAPACITY).order(ByteOrder.LITTLE_ENDIAN);

    /**
     * Creates an empty byte buffer for packing values.
     */
    public ByteBuf() {
    }

    /**
     * Wraps existing bytes for unpacking values.
     */
    public ByteBuf(byte[] bytes) {
        this.buffer = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN);
    }

    /**
     * Returns the packed bytes written to this buffer.
     */
    public byte[] asBytes() {
        byte[] out = new byte[buffer.position()];
        buffer.rewind();
        buffer.get(out, 0, out.length);
        return out;
    }

    /**
     * Grows the packing buffer when the next value does not fit.
     */
    private void ensureCapacity(int additionalLength) {
        int requiredLength = buffer.position() + additionalLength;
        if (requiredLength <= buffer.capacity()) {
            return;
        }

        int capacity = buffer.capacity();
        while (capacity < requiredLength) {
            capacity *= 2;
        }

        ByteBuffer expanded = ByteBuffer.allocate(capacity).order(ByteOrder.LITTLE_ENDIAN);
        buffer.flip();
        expanded.put(buffer);
        buffer = expanded;
    }

    /**
     * Packs an unsigned 16-bit protocol value represented by a Java short.
     */
    public ByteBuf put(short v) {
        ensureCapacity(Short.BYTES);
        buffer.putShort(v);
        return this;
    }

    /**
     * Packs a length-prefixed byte array.
     */
    public ByteBuf put(byte[] v) {
        put((short)v.length);
        ensureCapacity(v.length);
        buffer.put(v);
        return this;
    }

    /**
     * Appends bytes without a length prefix.
     */
    public ByteBuf copy(byte[] v) {
        ensureCapacity(v.length);
        buffer.put(v);
        return this;
    }

    /**
     * Packs an unsigned 32-bit protocol value represented by a Java int.
     */
    public ByteBuf put(int v) {
        ensureCapacity(Integer.BYTES);
        buffer.putInt(v);
        return this;
    }

    /**
     * Packs a 64-bit integer.
     */
    public ByteBuf put(long v) {
        ensureCapacity(Long.BYTES);
        buffer.putLong(v);
        return this;
    }

    /**
     * Packs a length-prefixed string.
     */
    public ByteBuf put(String v) {
        return put(v.getBytes());
    }

    /**
     * Packs a map of short keys and string values.
     */
    public ByteBuf put(TreeMap<Short, String> extra) {
        put((short)extra.size());

        for (Map.Entry<Short, String> pair : extra.entrySet()) {
            put(pair.getKey());
            put(pair.getValue());
        }

        return this;
    }

    /**
     * Packs a map of short keys and integer values.
     */
    public ByteBuf putIntMap(TreeMap<Short, Integer> extra) {
        put((short)extra.size());

        for (Map.Entry<Short, Integer> pair : extra.entrySet()) {
            put(pair.getKey());
            put(pair.getValue());
        }

        return this;
    }

    /**
     * Reads a 16-bit protocol value.
     */
    public short readShort() {
        return buffer.getShort();
    }

    /**
     * Reads a 32-bit protocol value.
     */
    public int readInt() {
        return buffer.getInt();
    }

    /**
     * Reads a length-prefixed byte array.
     */
    public byte[] readBytes() {
        short length = readShort();
        byte[] bytes = new byte[length];
        buffer.get(bytes);
        return bytes;
    }

    /**
     * Reads a length-prefixed string.
     */
    public String readString() {
        byte[] bytes = readBytes();
        return new String(bytes);
    }

    /**
     * Reads a map of short keys and string values.
     */
    public TreeMap readMap() {
        TreeMap<Short, String> map = new TreeMap<>();

        short length = readShort();

        for (short i = 0; i < length; ++i) {
            short k = readShort();
            String v = readString();
            map.put(k, v);
        }

        return map;
    }

    /**
     * Reads a map of short keys and integer values.
     */
    public TreeMap<Short, Integer> readIntMap() {
        TreeMap<Short, Integer> map = new TreeMap<>();

        short length = readShort();

        for (short i = 0; i < length; ++i) {
            short k = readShort();
            Integer v = readInt();
            map.put(k, v);
        }

        return map;
    }
}
