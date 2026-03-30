package io.agora.media

import java.util.*
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

class AccessToken2 {
    enum class PrivilegeRtc(val intValue: Short) {
        PRIVILEGE_JOIN_CHANNEL(1),
        PRIVILEGE_PUBLISH_AUDIO_STREAM(2),
        PRIVILEGE_PUBLISH_VIDEO_STREAM(3),
        PRIVILEGE_PUBLISH_DATA_STREAM(4);
    }

    enum class PrivilegeRtm(val intValue: Short) {
        PRIVILEGE_LOGIN(1);
    }

    enum class PrivilegeFpa(val intValue: Short) {
        PRIVILEGE_LOGIN(1);
    }

    enum class PrivilegeChat(val intValue: Short) {
        PRIVILEGE_CHAT_USER(1),
        PRIVILEGE_CHAT_APP(2);
    }

    enum class PrivilegeApaas(val intValue: Short) {
        PRIVILEGE_ROOM_USER(1),
        PRIVILEGE_USER(2),
        PRIVILEGE_APP(3);
    }

    var appCert: String = ""
    var appId: String = ""
    var expire: Int = 0
    var issueTs: Int = 0
    var salt: Int = 0
    var services: MutableMap<Short, Service> = TreeMap()

    constructor()

    constructor(appId: String, appCert: String, expire: Int) {
        this.appCert = appCert
        this.appId = appId
        this.expire = expire
        this.issueTs = Utils.getTimestamp()
        this.salt = Utils.randomInt()
    }

    fun addService(service: Service) {
        services[service.serviceType] = service
    }

    @Throws(Exception::class)
    fun build(): String {
        if (!Utils.isUUID(appId) || !Utils.isUUID(appCert)) {
            return ""
        }

        val buf = ByteBuf()
            .put(appId)
            .put(issueTs)
            .put(expire)
            .put(salt)
            .put(services.size.toShort())

        val signing = getSign()

        services.forEach { (_, v) ->
            v.pack(buf)
        }

        val mac = Mac.getInstance("HmacSHA256")
        mac.init(SecretKeySpec(signing, "HmacSHA256"))
        val signature = mac.doFinal(buf.asBytes())

        val bufferContent = ByteBuf()
        bufferContent.put(signature)
        bufferContent.buffer.put(buf.asBytes())

        return getVersion() + Utils.base64Encode(Utils.compress(bufferContent.asBytes()))
    }

    fun getService(serviceType: Short): Service {
        return when (serviceType) {
            SERVICE_TYPE_RTC -> ServiceRtc()
            SERVICE_TYPE_RTM -> ServiceRtm()
            SERVICE_TYPE_FPA -> ServiceFpa()
            SERVICE_TYPE_CHAT -> ServiceChat()
            SERVICE_TYPE_APAAS -> ServiceApaas()
            else -> throw IllegalArgumentException("unknown service type: `$serviceType`")
        }
    }

    @Throws(Exception::class)
    fun getSign(): ByteArray {
        val mac = Mac.getInstance("HmacSHA256")
        mac.init(SecretKeySpec(ByteBuf().put(issueTs).asBytes(), "HmacSHA256"))
        val signing = mac.doFinal(appCert.toByteArray())
        mac.init(SecretKeySpec(ByteBuf().put(salt).asBytes(), "HmacSHA256"))
        return mac.doFinal(signing)
    }

    fun parse(token: String): Boolean {
        if (getVersion() != token.substring(0, Utils.VERSION_LENGTH)) {
            return false
        }

        return try {
            val data = Utils.decompress(Utils.base64Decode(token.substring(Utils.VERSION_LENGTH)))
            val buff = ByteBuf(data)
            val signature = buff.readString()
            appId = buff.readString()
            issueTs = buff.readInt()
            expire = buff.readInt()
            salt = buff.readInt()
            val servicesNum = buff.readShort()

            for (i in 0 until servicesNum) {
                val serviceType = buff.readShort()
                val service = getService(serviceType)
                service.unpack(buff)
                services[serviceType] = service
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    open class Service(val type: Short) {
        var privileges: TreeMap<Short, Int> = TreeMap()

        fun addPrivilegeRtc(privilege: PrivilegeRtc, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        fun addPrivilegeRtm(privilege: PrivilegeRtm, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        fun addPrivilegeFpa(privilege: PrivilegeFpa, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        fun addPrivilegeChat(privilege: PrivilegeChat, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        fun addPrivilegeApaas(privilege: PrivilegeApaas, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        val serviceType: Short
            get() = type

        open fun pack(buf: ByteBuf): ByteBuf {
            return buf.put(type).putIntMap(privileges)
        }

        open fun unpack(byteBuf: ByteBuf) {
            privileges = byteBuf.readIntMap()
        }
    }

    class ServiceRtc : Service {
        var channelName: String = ""
        var uid: String = ""

        constructor() : super(SERVICE_TYPE_RTC)

        constructor(channelName: String, uid: String) : super(SERVICE_TYPE_RTC) {
            this.channelName = channelName
            this.uid = uid
        }

        override fun pack(buf: ByteBuf): ByteBuf {
            return super.pack(buf).put(channelName).put(uid)
        }

        override fun unpack(byteBuf: ByteBuf) {
            super.unpack(byteBuf)
            channelName = byteBuf.readString()
            uid = byteBuf.readString()
        }
    }

    class ServiceRtm : Service {
        var userId: String = ""

        constructor() : super(SERVICE_TYPE_RTM)

        constructor(userId: String) : super(SERVICE_TYPE_RTM) {
            this.userId = userId
        }

        override fun pack(buf: ByteBuf): ByteBuf {
            return super.pack(buf).put(userId)
        }

        override fun unpack(byteBuf: ByteBuf) {
            super.unpack(byteBuf)
            userId = byteBuf.readString()
        }
    }

    class ServiceFpa : Service {
        constructor() : super(SERVICE_TYPE_FPA)

        override fun pack(buf: ByteBuf): ByteBuf {
            return super.pack(buf)
        }

        override fun unpack(byteBuf: ByteBuf) {
            super.unpack(byteBuf)
        }
    }

    class ServiceChat : Service {
        var userId: String = ""

        constructor() : super(SERVICE_TYPE_CHAT)

        constructor(userId: String) : super(SERVICE_TYPE_CHAT) {
            this.userId = userId
        }

        override fun pack(buf: ByteBuf): ByteBuf {
            return super.pack(buf).put(userId)
        }

        override fun unpack(byteBuf: ByteBuf) {
            super.unpack(byteBuf)
            userId = byteBuf.readString()
        }
    }

    class ServiceApaas : Service {
        var roomUuid: String = ""
        var userUuid: String = ""
        var role: Short = -1

        constructor() : super(SERVICE_TYPE_APAAS)

        constructor(roomUuid: String, userUuid: String, role: Short) : super(SERVICE_TYPE_APAAS) {
            this.roomUuid = roomUuid
            this.userUuid = userUuid
            this.role = role
        }

        constructor(userUuid: String) : super(SERVICE_TYPE_APAAS) {
            this.userUuid = userUuid
        }

        override fun pack(buf: ByteBuf): ByteBuf {
            return super.pack(buf).put(roomUuid).put(userUuid).put(role)
        }

        override fun unpack(byteBuf: ByteBuf) {
            super.unpack(byteBuf)
            roomUuid = byteBuf.readString()
            userUuid = byteBuf.readString()
            role = byteBuf.readShort()
        }
    }

    companion object {
        private const val VERSION = "007"
        const val SERVICE_TYPE_RTC: Short = 1
        const val SERVICE_TYPE_RTM: Short = 2
        const val SERVICE_TYPE_FPA: Short = 4
        const val SERVICE_TYPE_CHAT: Short = 5
        const val SERVICE_TYPE_APAAS: Short = 7

        fun getUidStr(uid: Int): String {
            return if (uid == 0) {
                ""
            } else {
                (uid.toLong() and 0xFFFFFFFFL).toString()
            }
        }

        fun getVersion(): String {
            return VERSION
        }
    }
}
