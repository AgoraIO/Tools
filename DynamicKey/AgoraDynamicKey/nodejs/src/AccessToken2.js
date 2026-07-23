var crypto = require('crypto')
const zlib = require('zlib')
const VERSION_LENGTH = 3

// Returns the Token007 version prefix.
const getVersion = () => {
    return '007'
}

// Returns whether a value is a 32-character hexadecimal identifier.
const isUuid = value => {
    return value !== null && typeof value !== 'undefined' && /^[0-9a-fA-F]{32}$/.test(value.toString())
}

// Represents the common service type and privilege payload.
class Service {
    // Creates a service with the specified numeric type.
    constructor(service_type) {
        this.__type = service_type
        this.__privileges = {}
    }

    // Serializes the numeric service type.
    __pack_type() {
        let buf = new ByteBuf()
        buf.putUint16(this.__type)
        return buf.pack()
    }

    // Serializes the service privilege map.
    __pack_privileges() {
        let buf = new ByteBuf()
        buf.putTreeMapUInt32(this.__privileges)
        return buf.pack()
    }

    // Returns the numeric service type.
    service_type() {
        return this.__type
    }

    // Adds or updates a service privilege expiration timestamp.
    add_privilege(privilege, expire) {
        this.__privileges[privilege] = expire
    }

    // Serializes the service type and privileges.
    pack() {
        return Buffer.concat([this.__pack_type(), this.__pack_privileges()])
    }

    // Deserializes service privileges after the type has been consumed.
    unpack(buffer) {
        let bufReader = new ReadByteBuf(buffer)
        this.__privileges = bufReader.getTreeMapUInt32()
        return bufReader
    }
}

const kRtcServiceType = 1

// Represents an RTC service payload.
class ServiceRtc extends Service {
    // Creates an RTC service for a channel and user ID.
    constructor(channel_name, uid) {
        super(kRtcServiceType)
        this.__channel_name = channel_name
        this.__uid = uid === 0 ? '' : `${uid}`
    }

    // Serializes the RTC service payload.
    pack() {
        let buffer = new ByteBuf()
        buffer.putString(this.__channel_name).putString(this.__uid)
        return Buffer.concat([super.pack(), buffer.pack()])
    }

    // Deserializes the RTC service payload.
    unpack(buffer) {
        let bufReader = super.unpack(buffer)
        this.__channel_name = bufReader.getString()
        this.__uid = bufReader.getString()
        return bufReader
    }
}

ServiceRtc.kPrivilegeJoinChannel = 1
ServiceRtc.kPrivilegePublishAudioStream = 2
ServiceRtc.kPrivilegePublishVideoStream = 3
ServiceRtc.kPrivilegePublishDataStream = 4

const kRtmServiceType = 2

// Represents an RTM service payload.
class ServiceRtm extends Service {
    // Creates an RTM service for a user ID.
    constructor(user_id) {
        super(kRtmServiceType)
        this.__user_id = user_id || ''
    }

    // Serializes the RTM service payload.
    pack() {
        let buffer = new ByteBuf()
        buffer.putString(this.__user_id)
        return Buffer.concat([super.pack(), buffer.pack()])
    }

    // Deserializes the RTM service payload.
    unpack(buffer) {
        let bufReader = super.unpack(buffer)
        this.__user_id = bufReader.getString()
        return bufReader
    }
}

ServiceRtm.kPrivilegeLogin = 1

const kFpaServiceType = 4

// Represents an FPA service payload.
class ServiceFpa extends Service {
    // Creates an FPA service.
    constructor() {
        super(kFpaServiceType)
    }

    // Serializes the FPA service payload.
    pack() {
        return super.pack()
    }

    // Deserializes the FPA service payload.
    unpack(buffer) {
        let bufReader = super.unpack(buffer)
        return bufReader
    }
}

ServiceFpa.kPrivilegeLogin = 1

const kChatServiceType = 5

// Represents a Chat service payload.
class ServiceChat extends Service {
    // Creates a Chat service for a user ID.
    constructor(user_id) {
        super(kChatServiceType)
        this.__user_id = user_id || ''
    }

    // Serializes the Chat service payload.
    pack() {
        let buffer = new ByteBuf()
        buffer.putString(this.__user_id)
        return Buffer.concat([super.pack(), buffer.pack()])
    }

    // Deserializes the Chat service payload.
    unpack(buffer) {
        let bufReader = super.unpack(buffer)
        this.__user_id = bufReader.getString()
        return bufReader
    }
}

ServiceChat.kPrivilegeUser = 1
ServiceChat.kPrivilegeApp = 2

const kApaasServiceType = 7

// Represents an APaaS service payload.
class ServiceApaas extends Service {
    // Creates an APaaS service for a room, user, and role.
    constructor(roomUuid, userUuid, role) {
        super(kApaasServiceType)
        this.__room_uuid = roomUuid || ''
        this.__user_uuid = userUuid || ''
        this.__role = role || -1
    }

    // Serializes the APaaS service payload.
    pack() {
        let buffer = new ByteBuf()
        buffer.putString(this.__room_uuid)
        buffer.putString(this.__user_uuid)
        buffer.putInt16(this.__role)
        return Buffer.concat([super.pack(), buffer.pack()])
    }

    // Deserializes the APaaS service payload.
    unpack(buffer) {
        let bufReader = super.unpack(buffer)
        this.__room_uuid = bufReader.getString()
        this.__user_uuid = bufReader.getString()
        this.__role = bufReader.getInt16()
        return bufReader
    }
}

ServiceApaas.PRIVILEGE_ROOM_USER = 1
ServiceApaas.PRIVILEGE_USER = 2
ServiceApaas.PRIVILEGE_APP = 3

// Builds, parses, and verifies Token007 tokens containing one or more services.
class AccessToken2 {
    // Creates a token builder or an empty token parser.
    constructor(appId, appCertificate, issueTs, expire) {
        this.appId = appId
        this.appCertificate = appCertificate
        this.issueTs = issueTs || new Date().getTime() / 1000
        this.expire = expire
        // salt ranges in (1, 99999999)
        this.salt = Math.floor(Math.random() * 99999999) + 1
        this.services = []
        this.__signature = Buffer.alloc(0)
        this.__signing_info = Buffer.alloc(0)
    }

    // Derives the signing key with the stored or supplied App Certificate.
    __signing(appCertificate = this.appCertificate) {
        let signing = encodeHMac(new ByteBuf().putUint32(this.issueTs).pack(), appCertificate)
        signing = encodeHMac(new ByteBuf().putUint32(this.salt).pack(), signing)
        return signing
    }

    // Validates the fields required to build a token.
    __build_check() {
        const { appId, appCertificate, services } = this
        if (!isUuid(appId) || !isUuid(appCertificate)) {
            return false
        }

        if (services.length === 0) {
            return false
        }
        return true
    }

    // Returns services in stable type order while preserving duplicate insertion order.
    __services_for_packing() {
        return this.services
            .map((service, index) => ({ service, index }))
            .sort((left, right) => {
                const typeDifference = left.service.service_type() - right.service.service_type()
                return typeDifference || left.index - right.index
            })
            .map(entry => entry.service)
    }

    // Adds a service without replacing services of the same type.
    add_service(service) {
        this.services.push(service)
    }

    // Returns all services of the requested type in insertion or token order.
    getServices(serviceType) {
        return this.services.filter(service => service.service_type() === serviceType)
    }

    // Builds a Token007 token containing all added services.
    build() {
        if (!this.__build_check()) {
            return ''
        }

        let signing = this.__signing()
        const services = this.__services_for_packing()
        let signing_info = new ByteBuf()
            .putString(this.appId)
            .putUint32(this.issueTs)
            .putUint32(this.expire)
            .putUint32(this.salt)
            .putUint16(services.length)
            .pack()
        services.forEach(service => {
            signing_info = Buffer.concat([signing_info, service.pack()])
        })

        let signature = encodeHMac(signing, signing_info)
        let content = Buffer.concat([new ByteBuf().putString(signature).pack(), signing_info])
        let compressed = zlib.deflateSync(content)
        return `${getVersion()}${Buffer.from(compressed).toString('base64')}`
    }

    // Parses known services and retains the original bytes for signature verification.
    from_string(origin_token) {
        if (typeof origin_token !== 'string' || origin_token.length < VERSION_LENGTH) {
            return false
        }

        const origin_version = origin_token.substring(0, VERSION_LENGTH)
        if (origin_version !== getVersion()) {
            return false
        }

        try {
            const origin_content = origin_token.substring(VERSION_LENGTH)
            const buffer = zlib.inflateSync(Buffer.from(origin_content, 'base64'))
            const bufferReader = new ReadByteBuf(buffer)

            this.__signature = Buffer.from(bufferReader.getString())
            this.__signing_info = Buffer.from(bufferReader.pack())
            this.services = []
            this.appId = bufferReader.getString()
            this.issueTs = bufferReader.getUint32()
            this.expire = bufferReader.getUint32()
            this.salt = bufferReader.getUint32()
            const service_count = bufferReader.getUint16()

            let remainBuf = bufferReader.pack()
            for (let i = 0; i < service_count; i++) {
                const bufferReaderService = new ReadByteBuf(remainBuf)
                const service_type = bufferReaderService.getUint16()
                const ServiceClass = AccessToken2.kServices[service_type]
                if (!ServiceClass) {
                    return true
                }

                const service = new ServiceClass()
                remainBuf = service.unpack(bufferReaderService.pack()).pack()
                this.add_service(service)
            }
        } catch (error) {
            return false
        }

        return true
    }

    // Verifies the signature of a successfully parsed token.
    verifySignature(appCertificate) {
        if (this.__signature.length === 0 || this.__signing_info.length === 0
            || !isUuid(this.appId) || !isUuid(appCertificate)) {
            return false
        }

        const signature = encodeHMac(this.__signing(appCertificate), this.__signing_info)
        return this.__signature.length === signature.length
            && crypto.timingSafeEqual(this.__signature, signature)
    }
}

// Returns a SHA-256 HMAC digest.
var encodeHMac = function (key, message) {
    return crypto.createHmac('sha256', key).update(message).digest()
}

// Creates a little-endian token buffer writer.
var ByteBuf = function () {
    var that = {
        buffer: Buffer.alloc(1024),
        position: 0
    }

    that.buffer.fill(0)

    // Returns the bytes written to the buffer.
    that.pack = function () {
        var out = Buffer.alloc(that.position)
        that.buffer.copy(out, 0, 0, out.length)
        return out
    }

    // Appends an unsigned 16-bit integer.
    that.putUint16 = function (v) {
        that.buffer.writeUInt16LE(v, that.position)
        that.position += 2
        return that
    }

    // Appends an unsigned 32-bit integer.
    that.putUint32 = function (v) {
        that.buffer.writeUInt32LE(v, that.position)
        that.position += 4
        return that
    }
    // Appends a signed 32-bit integer.
    that.putInt32 = function (v) {
        that.buffer.writeInt32LE(v, that.position)
        that.position += 4
        return that
    }

    // Appends a signed 16-bit integer.
    that.putInt16 = function (v) {
        that.buffer.writeInt16LE(v, that.position)
        that.position += 2
        return that
    }

    // Appends length-prefixed bytes.
    that.putBytes = function (bytes) {
        that.putUint16(bytes.length)
        bytes.copy(that.buffer, that.position)
        that.position += bytes.length
        return that
    }

    // Appends a length-prefixed string.
    that.putString = function (str) {
        return that.putBytes(Buffer.from(str))
    }

    // Appends a string map in numeric key order.
    that.putTreeMap = function (map) {
        if (!map) {
            that.putUint16(0)
            return that
        }

        that.putUint16(Object.keys(map).length)
        for (var key in map) {
            that.putUint16(key)
            that.putString(map[key])
        }

        return that
    }

    // Appends an unsigned 32-bit value map in numeric key order.
    that.putTreeMapUInt32 = function (map) {
        if (!map) {
            that.putUint16(0)
            return that
        }

        that.putUint16(Object.keys(map).length)
        for (var key in map) {
            that.putUint16(key)
            that.putUint32(map[key])
        }

        return that
    }

    return that
}

// Creates a little-endian token buffer reader.
var ReadByteBuf = function (bytes) {
    var that = {
        buffer: bytes,
        position: 0
    }

    // Reads an unsigned 16-bit integer.
    that.getUint16 = function () {
        var ret = that.buffer.readUInt16LE(that.position)
        that.position += 2
        return ret
    }

    // Reads an unsigned 32-bit integer.
    that.getUint32 = function () {
        var ret = that.buffer.readUInt32LE(that.position)
        that.position += 4
        return ret
    }

    // Reads a signed 16-bit integer.
    that.getInt16 = function () {
        var ret = that.buffer.readUInt16LE(that.position)
        that.position += 2
        return ret
    }

    // Reads length-prefixed bytes.
    that.getString = function () {
        var len = that.getUint16()

        var out = Buffer.alloc(len)
        that.buffer.copy(out, 0, that.position, that.position + len)
        that.position += len
        return out
    }

    // Reads an unsigned 32-bit value map.
    that.getTreeMapUInt32 = function () {
        var map = {}
        var len = that.getUint16()
        for (var i = 0; i < len; i++) {
            var key = that.getUint16()
            var value = that.getUint32()
            map[key] = value
        }
        return map
    }

    // Returns unread bytes from the buffer.
    that.pack = function () {
        const length = that.buffer.length - that.position
        const out = Buffer.alloc(length)
        that.buffer.copy(out, 0, that.position)
        return out
    }

    return that
}

AccessToken2.kServices = {}
AccessToken2.kServices[kApaasServiceType] = ServiceApaas
AccessToken2.kServices[kChatServiceType] = ServiceChat
AccessToken2.kServices[kFpaServiceType] = ServiceFpa
AccessToken2.kServices[kRtcServiceType] = ServiceRtc
AccessToken2.kServices[kRtmServiceType] = ServiceRtm

module.exports = {
    AccessToken2,
    kApaasServiceType,
    kChatServiceType,
    kFpaServiceType,
    kRtcServiceType,
    kRtmServiceType,
    Service,
    ServiceApaas,
    ServiceChat,
    ServiceFpa,
    ServiceRtc,
    ServiceRtm
}
