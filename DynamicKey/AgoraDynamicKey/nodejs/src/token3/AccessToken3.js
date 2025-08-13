var crypto = require('crypto')
const zlib = require('zlib')
const VERSION_LENGTH = 3
const APP_ID_LENGTH = 32

const getVersion = () => {
    return '007'
}

class Service {
    constructor(service_type) {
        this.__type = service_type
        this.__privileges = {}
    }

    __pack_type() {
        let buf = new ByteBuf()
        buf.putUint16(this.__type)
        return buf.pack()
    }

    __pack_privileges() {
        let buf = new ByteBuf()
        buf.putTreeMapUInt32(this.__privileges)
        return buf.pack()
    }

    service_type() {
        return this.__type
    }

    add_privilege(privilege, expire) {
        this.__privileges[privilege] = expire
    }

    pack() {
        return Buffer.concat([this.__pack_type(), this.__pack_privileges()])
    }

    unpack(buffer) {
        let bufReader = new ReadByteBuf(buffer)
        this.__privileges = bufReader.getTreeMapUInt32()
        return bufReader
    }
}

const kRtcServiceType = 1

class ServiceRtc extends Service {
    constructor(channel_name, uid) {
        super(kRtcServiceType)
        this.__channel_name = channel_name
        this.__uid = uid === 0 ? '' : `${uid}`
    }

    pack() {
        let buffer = new ByteBuf()
        buffer.putString(this.__channel_name).putString(this.__uid)
        return Buffer.concat([super.pack(), buffer.pack()])
    }

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

const kRtmServiceType = 8

class ServiceRtm extends Service {
    constructor(user_id, permissions) {
        super(kRtmServiceType)
        this.__user_id = user_id || ''
        this.__permissions = permissions
    }

    pack() {
        let buffer = new ByteBuf()
        buffer.putString(this.__user_id)
        buffer.putPermissions(this.__permissions)
        return Buffer.concat([super.pack(), buffer.pack()])
    }

    unpack(buffer) {
        let bufReader = super.unpack(buffer)
        this.__user_id = bufReader.getString()
        this.__permissions = bufReader.getPermissions()
        return bufReader
    }
}

ServiceRtm.kPrivilegeLogin = 1

const kFpaServiceType = 4

class ServiceFpa extends Service {
    constructor() {
        super(kFpaServiceType)
    }

    pack() {
        return super.pack()
    }

    unpack(buffer) {
        let bufReader = super.unpack(buffer)
        return bufReader
    }
}

ServiceFpa.kPrivilegeLogin = 1

const kChatServiceType = 5

class ServiceChat extends Service {
    constructor(user_id) {
        super(kChatServiceType)
        this.__user_id = user_id || ''
    }

    pack() {
        let buffer = new ByteBuf()
        buffer.putString(this.__user_id)
        return Buffer.concat([super.pack(), buffer.pack()])
    }

    unpack(buffer) {
        let bufReader = super.unpack(buffer)
        this.__user_id = bufReader.getString()
        return bufReader
    }
}

ServiceChat.kPrivilegeUser = 1
ServiceChat.kPrivilegeApp = 2

const kApaasServiceType = 7

class ServiceApaas extends Service {
    constructor(roomUuid, userUuid, role) {
        super(kApaasServiceType)
        this.__room_uuid = roomUuid || ''
        this.__user_uuid = userUuid || ''
        this.__role = role || -1
    }

    pack() {
        let buffer = new ByteBuf()
        buffer.putString(this.__room_uuid)
        buffer.putString(this.__user_uuid)
        buffer.putInt16(this.__role)
        return Buffer.concat([super.pack(), buffer.pack()])
    }

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

class AccessToken3 {
    constructor(appId, appCertificate, issueTs, expire) {
        this.appId = appId
        this.appCertificate = appCertificate
        this.issueTs = issueTs || new Date().getTime() / 1000
        this.expire = expire
        // salt ranges in (1, 99999999)
        this.salt = Math.floor(Math.random() * 99999999) + 1
        this.services = {}
    }

    __signing() {
        let signing = encodeHMac(new ByteBuf().putUint32(this.issueTs).pack(), this.appCertificate)
        signing = encodeHMac(new ByteBuf().putUint32(this.salt).pack(), signing)
        return signing
    }

    __build_check() {
        let is_uuid = data => {
            if (data.length !== APP_ID_LENGTH) {
                return false
            }
            let buf = Buffer.from(data, 'hex')
            return !!buf
        }

        const { appId, appCertificate, services } = this
        if (!is_uuid(appId) || !is_uuid(appCertificate)) {
            return false
        }

        if (Object.keys(services).length === 0) {
            return false
        }
        return true
    }

    add_service(service) {
        this.services[service.service_type()] = service
    }

    build() {
        if (!this.__build_check()) {
            return ''
        }

        let signing = this.__signing()
        let signing_info = new ByteBuf()
            .putString(this.appId)
            .putUint32(this.issueTs)
            .putUint32(this.expire)
            .putUint32(this.salt)
            .putUint16(Object.keys(this.services).length)
            .pack()
        Object.values(this.services).forEach(service => {
            signing_info = Buffer.concat([signing_info, service.pack()])
        })

        let signature = encodeHMac(signing, signing_info)
        let content = Buffer.concat([new ByteBuf().putString(signature).pack(), signing_info])
        let compressed = zlib.deflateSync(content)
        return `${getVersion()}${Buffer.from(compressed).toString('base64')}`
    }

    from_string(origin_token) {
        let origin_version = origin_token.substring(0, VERSION_LENGTH)
        if (origin_version !== getVersion()) {
            return false
        }

        let origin_content = origin_token.substring(VERSION_LENGTH, origin_token.length)
        let buffer = zlib.inflateSync(new Buffer(origin_content, 'base64'))
        let bufferReader = new ReadByteBuf(buffer)

        let signature = bufferReader.getString()
        this.appId = bufferReader.getString()
        this.issueTs = bufferReader.getUint32()
        this.expire = bufferReader.getUint32()
        this.salt = bufferReader.getUint32()
        let service_count = bufferReader.getUint16()

        let remainBuf = bufferReader.pack()
        for (let i = 0; i < service_count; i++) {
            let bufferReaderService = new ReadByteBuf(remainBuf)
            let service_type = bufferReaderService.getUint16()
            let service = new AccessToken3.kServices[service_type]()
            remainBuf = service.unpack(bufferReaderService.pack()).pack()
            this.services[service_type] = service
        }

        // TODO:
        console.log('Parse result: ', {
            // signature,
            appId: new TextDecoder().decode(this.appId),
            issueTs: this.issueTs,
            expire: this.expire,
            salt: this.salt,
            service_count,
            // services: new TextDecoder().decode(this.services[kRtmServiceType].__permissions),
            user_id: new TextDecoder().decode(this.services[kRtmServiceType].__user_id),
            services: this.services[kRtmServiceType].__permissions,
            permissions_0: this.services[kRtmServiceType].__permissions.get(0),
            permissions_1: this.services[kRtmServiceType].__permissions.get(1)
        })
    }
}

var encodeHMac = function (key, message) {
    return crypto.createHmac('sha256', key).update(message).digest()
}

var ByteBuf = function () {
    var that = {
        buffer: Buffer.alloc(1024),
        position: 0
    }

    that.buffer.fill(0)

    that.pack = function () {
        var out = Buffer.alloc(that.position)
        that.buffer.copy(out, 0, 0, out.length)
        return out
    }

    that.putUint16 = function (v) {
        that.buffer.writeUInt16LE(v, that.position)
        that.position += 2
        return that
    }

    that.putUint32 = function (v) {
        that.buffer.writeUInt32LE(v, that.position)
        that.position += 4
        return that
    }
    that.putInt32 = function (v) {
        that.buffer.writeInt32LE(v, that.position)
        that.position += 4
        return that
    }

    that.putInt16 = function (v) {
        that.buffer.writeInt16LE(v, that.position)
        that.position += 2
        return that
    }

    that.putBytes = function (bytes) {
        that.putUint16(bytes.length)
        bytes.copy(that.buffer, that.position)
        that.position += bytes.length
        return that
    }

    that.putString = function (str) {
        return that.putBytes(Buffer.from(str))
    }

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

    that.putPermissions = function (permissions) {
        if (!permissions) {
            that.putUint16(0)
            return that
        }

        // support Map and Object
        var keys, getValue
        if (permissions instanceof Map) {
            keys = Array.from(permissions.keys())
            getValue = function (key) {
                return permissions.get(key)
            }
        } else {
            keys = Object.keys(permissions)
            getValue = function (key) {
                return permissions[key]
            }
        }

        that.putUint16(keys.length)

        for (var i = 0; i < keys.length; i++) {
            var key = parseInt(keys[i])
            var innerMap = getValue(key)

            // serialize outer key (uint16_t)
            that.putUint16(key)

            // serialize inner map
            if (!innerMap) {
                that.putUint16(0)
            } else {
                var innerKeys, getInnerValue
                if (innerMap instanceof Map) {
                    innerKeys = Array.from(innerMap.keys())
                    getInnerValue = function (key) {
                        return innerMap.get(key)
                    }
                } else {
                    innerKeys = Object.keys(innerMap)
                    getInnerValue = function (key) {
                        return innerMap[key]
                    }
                }

                that.putUint16(innerKeys.length)

                for (var j = 0; j < innerKeys.length; j++) {
                    var innerKey = parseInt(innerKeys[j])
                    var vector = getInnerValue(innerKey)

                    // serialize inner key (uint16_t)
                    that.putUint16(innerKey)

                    // serialize vector (string array)
                    if (!vector || !Array.isArray(vector)) {
                        that.putUint16(0)
                    } else {
                        that.putUint16(vector.length)
                        for (var k = 0; k < vector.length; k++) {
                            that.putString(vector[k] || '')
                        }
                    }
                }
            }
        }

        return that
    }

    return that
}

var ReadByteBuf = function (bytes) {
    var that = {
        buffer: bytes,
        position: 0
    }

    that.getUint16 = function () {
        var ret = that.buffer.readUInt16LE(that.position)
        that.position += 2
        return ret
    }

    that.getUint32 = function () {
        var ret = that.buffer.readUInt32LE(that.position)
        that.position += 4
        return ret
    }

    that.getInt16 = function () {
        var ret = that.buffer.readUInt16LE(that.position)
        that.position += 2
        return ret
    }

    that.getString = function () {
        var len = that.getUint16()

        var out = Buffer.alloc(len)
        that.buffer.copy(out, 0, that.position, that.position + len)
        that.position += len
        return out
    }

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

    that.getPermissions = function () {
        var permissions = new Map()
        var len = that.getUint16()

        for (var i = 0; i < len; i++) {
            // deserialize outer key (uint16_t)
            var key = that.getUint16()
            var innerMap = new Map()

            // deserialize inner map
            var innerLen = that.getUint16()
            for (var j = 0; j < innerLen; j++) {
                // deserialize inner key (uint16_t)
                var innerKey = that.getUint16()
                var vector = []

                // deserialize vector (string array)
                var vectorLen = that.getUint16()
                for (var k = 0; k < vectorLen; k++) {
                    vector.push(that.getString().toString())
                }

                innerMap.set(innerKey, vector)
            }

            permissions.set(key, innerMap)
        }

        return permissions
    }

    that.pack = function () {
        let length = that.buffer.length
        var out = Buffer.alloc(length)
        that.buffer.copy(out, 0, that.position, length)
        return out
    }

    return that
}

AccessToken3.kServices = {}
AccessToken3.kServices[kApaasServiceType] = ServiceApaas
AccessToken3.kServices[kChatServiceType] = ServiceChat
AccessToken3.kServices[kFpaServiceType] = ServiceFpa
AccessToken3.kServices[kRtcServiceType] = ServiceRtc
AccessToken3.kServices[kRtmServiceType] = ServiceRtm

module.exports = {
    AccessToken3,
    kApaasServiceType,
    kChatServiceType,
    kFpaServiceType,
    kRtcServiceType,
    kRtmServiceType,
    ServiceApaas,
    ServiceChat,
    ServiceFpa,
    ServiceRtc,
    ServiceRtm
}
