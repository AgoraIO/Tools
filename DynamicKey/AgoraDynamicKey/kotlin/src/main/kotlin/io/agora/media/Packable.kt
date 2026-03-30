package io.agora.media

interface Packable {
    fun marshal(out: ByteBuf): ByteBuf
}

interface PackableEx : Packable {
    fun unmarshal(`in`: ByteBuf)
}
