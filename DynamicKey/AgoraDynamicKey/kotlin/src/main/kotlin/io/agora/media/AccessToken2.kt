package io.agora.media

import java.nio.charset.StandardCharsets
import java.security.MessageDigest
import java.util.TreeMap
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

/** Builds, parses, and verifies Token007 tokens containing one or more services. */
class AccessToken2 {
    /** RTC privilege identifiers. */
    enum class PrivilegeRtc(val intValue: Short) {
        PRIVILEGE_JOIN_CHANNEL(1),
        PRIVILEGE_PUBLISH_AUDIO_STREAM(2),
        PRIVILEGE_PUBLISH_VIDEO_STREAM(3),
        PRIVILEGE_PUBLISH_DATA_STREAM(4)
    }

    /** RTM privilege identifiers. */
    enum class PrivilegeRtm(val intValue: Short) {
        PRIVILEGE_LOGIN(1)
    }

    /** Streaming privilege identifiers. */
    enum class PrivilegeStreaming(val intValue: Short) {
        PRIVILEGE_PUBLISH_MIX_STREAM(1),
        PRIVILEGE_PUBLISH_RAW_STREAM(2)
    }

    /** FPA privilege identifiers. */
    enum class PrivilegeFpa(val intValue: Short) {
        PRIVILEGE_LOGIN(1)
    }

    /** Chat privilege identifiers. */
    enum class PrivilegeChat(val intValue: Short) {
        PRIVILEGE_CHAT_USER(1),
        PRIVILEGE_CHAT_APP(2)
    }

    /** FCDN privilege identifiers. */
    enum class PrivilegeFCdn(val intValue: Short) {
        PRIVILEGE_PUBLISH(1),
        PRIVILEGE_PLAY(2)
    }

    /** APaaS privilege identifiers. */
    enum class PrivilegeApaas(val intValue: Short) {
        PRIVILEGE_ROOM_USER(1),
        PRIVILEGE_USER(2),
        PRIVILEGE_APP(3)
    }

    /** RTM2 privilege identifiers. */
    enum class PrivilegeRtm2(val intValue: Short) {
        PRIVILEGE_LOGIN(1)
    }

    var appCert: String = ""
    var appId: String = ""
    var expire: Int = 0
    var issueTs: Int = 0
    var salt: Int = 0
    val services: MutableList<Service> = mutableListOf()

    private var signature = ByteArray(0)
    private var signingInfo = ByteArray(0)
    private var parsed = false

    /** Creates an empty token parser. */
    constructor()

    /** Creates a Token007 builder. */
    constructor(appId: String, appCert: String, expire: Int) {
        this.appCert = appCert
        this.appId = appId
        this.expire = expire
        issueTs = Utils.getTimestamp()
        salt = Utils.randomInt()
    }

    /** Adds a service without replacing services of the same type. */
    fun addService(service: Service) {
        services.add(service)
    }

    /** Returns all services of the requested type in insertion or token order. */
    fun getServices(serviceType: Short): List<Service> = services.filter { it.serviceType == serviceType }

    /** Builds a Token007 token and requires at least one service. */
    fun build(): String {
        if (!Utils.isUUID(appId) || !Utils.isUUID(appCert) || services.isEmpty()) {
            return ""
        }

        val orderedServices = servicesForPacking()
        val signingInfo = ByteBuf()
            .put(appId)
            .put(issueTs)
            .put(expire)
            .put(salt)
            .put(orderedServices.size.toShort())
        orderedServices.forEach { it.pack(signingInfo) }

        val mac = Mac.getInstance(HMAC_SHA256)
        mac.init(SecretKeySpec(getSign(), HMAC_SHA256))
        val signingBytes = signingInfo.asBytes()
        val tokenSignature = mac.doFinal(signingBytes)
        val content = ByteBuf().put(tokenSignature).copy(signingBytes)
        return getVersion() + Utils.base64Encode(Utils.compress(content.asBytes()))
    }

    /** Creates a parser for a known service type or returns null for an unknown type. */
    fun getService(serviceType: Short): Service? = when (serviceType) {
        SERVICE_TYPE_RTC -> ServiceRtc()
        SERVICE_TYPE_RTM -> ServiceRtm()
        SERVICE_TYPE_STREAMING -> ServiceStreaming()
        SERVICE_TYPE_FPA -> ServiceFpa()
        SERVICE_TYPE_CHAT -> ServiceChat()
        SERVICE_TYPE_FCDN -> ServiceFCdn()
        SERVICE_TYPE_APAAS -> ServiceApaas()
        SERVICE_TYPE_RTM2 -> ServiceRtm2()
        else -> null
    }

    /** Derives the signing key with the stored App Certificate. */
    fun getSign(): ByteArray = getSign(appCert)

    /** Derives the signing key with the supplied App Certificate. */
    fun getSign(appCertificate: String): ByteArray {
        val mac = Mac.getInstance(HMAC_SHA256)
        mac.init(SecretKeySpec(ByteBuf().put(issueTs).asBytes(), HMAC_SHA256))
        val signing = mac.doFinal(appCertificate.toByteArray(StandardCharsets.UTF_8))
        mac.init(SecretKeySpec(ByteBuf().put(salt).asBytes(), HMAC_SHA256))
        return mac.doFinal(signing)
    }

    /** Parses known services and retains the original bytes for signature verification. */
    fun parse(token: String?): Boolean {
        resetParsedState()
        if (token == null || token.length < Utils.VERSION_LENGTH ||
            token.substring(0, Utils.VERSION_LENGTH) != getVersion()
        ) {
            return false
        }

        return try {
            val data = Utils.decompress(Utils.base64Decode(token.substring(Utils.VERSION_LENGTH)))
            val buffer = ByteBuf(data)
            signature = buffer.readBytes()
            signingInfo = data.copyOfRange(Short.SIZE_BYTES + signature.size, data.size)
            appId = buffer.readString()
            issueTs = buffer.readInt()
            expire = buffer.readInt()
            salt = buffer.readInt()
            val serviceCount = buffer.readShort().toInt() and 0xffff

            repeat(serviceCount) {
                val service = getService(buffer.readShort())
                if (service == null) {
                    parsed = true
                    return true
                }
                service.unpack(buffer)
                addService(service)
            }
            parsed = true
            true
        } catch (_: Exception) {
            resetParsedState()
            false
        }
    }

    /** Verifies the signature of a successfully parsed token. */
    fun verifySignature(appCertificate: String?): Boolean {
        if (!parsed || signature.isEmpty() || signingInfo.isEmpty() || appCertificate == null ||
            !Utils.isUUID(appId) || !Utils.isUUID(appCertificate)
        ) {
            return false
        }

        return try {
            val mac = Mac.getInstance(HMAC_SHA256)
            mac.init(SecretKeySpec(getSign(appCertificate), HMAC_SHA256))
            MessageDigest.isEqual(signature, mac.doFinal(signingInfo))
        } catch (_: Exception) {
            false
        }
    }

    /** Clears token state so a failed parse cannot reuse a previous signature or service list. */
    private fun resetParsedState() {
        parsed = false
        appId = ""
        issueTs = 0
        expire = 0
        salt = 0
        services.clear()
        signature = ByteArray(0)
        signingInfo = ByteArray(0)
    }

    /** Returns services in stable type order while preserving duplicate insertion order. */
    private fun servicesForPacking(): List<Service> =
        services.sortedBy { it.serviceType.toInt() and 0xffff }

    /** Represents the common service type and privilege payload. */
    open class Service(var type: Short = 0) {
        var privileges: TreeMap<Short, Int> = TreeMap()

        /** Adds or updates an RTC privilege expiration timestamp. */
        fun addPrivilegeRtc(privilege: PrivilegeRtc, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        /** Adds or updates an RTM privilege expiration timestamp. */
        fun addPrivilegeRtm(privilege: PrivilegeRtm, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        /** Adds or updates a Streaming privilege expiration timestamp. */
        fun addPrivilegeStreaming(privilege: PrivilegeStreaming, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        /** Adds or updates an FPA privilege expiration timestamp. */
        fun addPrivilegeFpa(privilege: PrivilegeFpa, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        /** Adds or updates a Chat privilege expiration timestamp. */
        fun addPrivilegeChat(privilege: PrivilegeChat, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        /** Adds or updates an FCDN privilege expiration timestamp. */
        fun addPrivilegeFCdn(privilege: PrivilegeFCdn, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        /** Adds or updates an APaaS privilege expiration timestamp. */
        fun addPrivilegeApaas(privilege: PrivilegeApaas, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        /** Adds or updates an RTM2 privilege expiration timestamp. */
        fun addPrivilegeRtm2(privilege: PrivilegeRtm2, expire: Int) {
            privileges[privilege.intValue] = expire
        }

        /** Returns the numeric service type. */
        val serviceType: Short
            get() = type

        /** Serializes the service type and privileges. */
        open fun pack(buffer: ByteBuf): ByteBuf = buffer.put(type).putIntMap(privileges)

        /** Deserializes service privileges after the type has been consumed. */
        open fun unpack(buffer: ByteBuf) {
            privileges = buffer.readIntMap()
        }
    }

    /** Represents RTC channel and user privileges. */
    class ServiceRtc(
        var channelName: String = "",
        var uid: String = ""
    ) : Service(SERVICE_TYPE_RTC) {
        /** Serializes the RTC service payload. */
        override fun pack(buffer: ByteBuf): ByteBuf = super.pack(buffer).put(channelName).put(uid)

        /** Deserializes the RTC service payload. */
        override fun unpack(buffer: ByteBuf) {
            super.unpack(buffer)
            channelName = buffer.readString()
            uid = buffer.readString()
        }
    }

    /** Represents RTM user login privileges. */
    class ServiceRtm(var userId: String = "") : Service(SERVICE_TYPE_RTM) {
        /** Serializes the RTM service payload. */
        override fun pack(buffer: ByteBuf): ByteBuf = super.pack(buffer).put(userId)

        /** Deserializes the RTM service payload. */
        override fun unpack(buffer: ByteBuf) {
            super.unpack(buffer)
            userId = buffer.readString()
        }
    }

    /** Represents Streaming channel and account privileges. */
    class ServiceStreaming(
        var channelName: String = "",
        var account: String = ""
    ) : Service(SERVICE_TYPE_STREAMING) {
        /** Creates a Streaming service with a numeric user ID. */
        constructor(channelName: String, uid: Long) : this(channelName, if (uid == 0L) "" else uid.toString())

        /** Serializes the Streaming service payload. */
        override fun pack(buffer: ByteBuf): ByteBuf = super.pack(buffer).put(channelName).put(account)

        /** Deserializes the Streaming service payload. */
        override fun unpack(buffer: ByteBuf) {
            super.unpack(buffer)
            channelName = buffer.readString()
            account = buffer.readString()
        }
    }

    /** Represents FPA login privileges. */
    class ServiceFpa : Service(SERVICE_TYPE_FPA)

    /** Represents Chat user or application privileges. */
    class ServiceChat(var userId: String = "") : Service(SERVICE_TYPE_CHAT) {
        /** Serializes the Chat service payload. */
        override fun pack(buffer: ByteBuf): ByteBuf = super.pack(buffer).put(userId)

        /** Deserializes the Chat service payload. */
        override fun unpack(buffer: ByteBuf) {
            super.unpack(buffer)
            userId = buffer.readString()
        }
    }

    /** Represents FCDN channel and account privileges. */
    class ServiceFCdn(
        var channelName: String = "",
        var account: String = ""
    ) : Service(SERVICE_TYPE_FCDN) {
        /** Creates an FCDN service with a numeric user ID. */
        constructor(channelName: String, uid: Long) : this(channelName, if (uid == 0L) "" else uid.toString())

        /** Serializes the FCDN service payload. */
        override fun pack(buffer: ByteBuf): ByteBuf = super.pack(buffer).put(channelName).put(account)

        /** Deserializes the FCDN service payload. */
        override fun unpack(buffer: ByteBuf) {
            super.unpack(buffer)
            channelName = buffer.readString()
            account = buffer.readString()
        }
    }

    /** Represents APaaS room, user, and application privileges. */
    class ServiceApaas(
        var roomUuid: String = "",
        var userUuid: String = "",
        var role: Short = (-1).toShort()
    ) : Service(SERVICE_TYPE_APAAS) {
        /** Creates an APaaS user service. */
        constructor(userUuid: String) : this("", userUuid, (-1).toShort())

        /** Serializes the APaaS service payload. */
        override fun pack(buffer: ByteBuf): ByteBuf = super.pack(buffer).put(roomUuid).put(userUuid).put(role)

        /** Deserializes the APaaS service payload. */
        override fun unpack(buffer: ByteBuf) {
            super.unpack(buffer)
            roomUuid = buffer.readString()
            userUuid = buffer.readString()
            role = buffer.readShort()
        }
    }

    /** Represents RTM2 login and resource-level permissions. */
    class ServiceRtm2(
        var userId: String = "",
        var permissions: Permissions = Permissions()
    ) : Service(SERVICE_TYPE_RTM2) {
        /** Stores RTM2 resource-level permissions in stable numeric key order. */
        class Permissions {
            val details: TreeMap<Short, TreeMap<Short, MutableList<String>>> = TreeMap()

            /** Adds or replaces resources for a resource and permission type. */
            fun add(resourceType: Short, permissionType: Short, resources: List<String>) {
                details.getOrPut(resourceType) { TreeMap() }[permissionType] = resources.toMutableList()
            }

            companion object {
                const val MESSAGE_CHANNELS: Short = 0
                const val STREAM_CHANNELS: Short = 1
                const val GROUP_CHANNELS: Short = 2
                const val SERVER_GROUPS: Short = 3
                const val USERS: Short = 4

                const val READ: Short = 0
                const val WRITE: Short = 1
            }
        }

        /** Serializes the RTM2 service payload. */
        override fun pack(buffer: ByteBuf): ByteBuf {
            super.pack(buffer).put(userId).put(permissions.details.size.toShort())
            permissions.details.forEach { (resourceType, permissionDetails) ->
                buffer.put(resourceType).put(permissionDetails.size.toShort())
                permissionDetails.forEach { (permissionType, resources) ->
                    buffer.put(permissionType).put(resources.size.toShort())
                    resources.forEach(buffer::put)
                }
            }
            return buffer
        }

        /** Deserializes the RTM2 service payload. */
        override fun unpack(buffer: ByteBuf) {
            super.unpack(buffer)
            userId = buffer.readString()
            permissions = Permissions()
            repeat(buffer.readShort().toInt() and 0xffff) {
                val resourceType = buffer.readShort()
                repeat(buffer.readShort().toInt() and 0xffff) {
                    val permissionType = buffer.readShort()
                    val resources = MutableList(buffer.readShort().toInt() and 0xffff) { buffer.readString() }
                    permissions.add(resourceType, permissionType, resources)
                }
            }
        }
    }

    companion object {
        private const val VERSION = "007"
        private const val HMAC_SHA256 = "HmacSHA256"

        const val SERVICE_TYPE_RTC: Short = 1
        const val SERVICE_TYPE_RTM: Short = 2
        const val SERVICE_TYPE_STREAMING: Short = 3
        const val SERVICE_TYPE_FPA: Short = 4
        const val SERVICE_TYPE_CHAT: Short = 5
        const val SERVICE_TYPE_FCDN: Short = 6
        const val SERVICE_TYPE_APAAS: Short = 7
        const val SERVICE_TYPE_RTM2: Short = 8

        /** Converts a numeric user ID to its unsigned token representation. */
        fun getUidStr(uid: Int): String = if (uid == 0) "" else (uid.toLong() and 0xffffffffL).toString()

        /** Returns the Token007 version prefix. */
        fun getVersion(): String = VERSION
    }
}
