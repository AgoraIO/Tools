package io.agora.media

/** Defines serialization into a Token007 byte buffer. */
interface Packable {
    /** Serializes this value into the supplied buffer. */
    fun marshal(out: ByteBuf): ByteBuf
}

/** Defines serialization and deserialization for a Token007 value. */
interface PackableEx : Packable {
    /** Deserializes this value from the supplied buffer. */
    fun unmarshal(`in`: ByteBuf)
}
