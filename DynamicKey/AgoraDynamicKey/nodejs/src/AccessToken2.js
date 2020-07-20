var crypto = require('crypto');
var crc32 = require('crc-32');
const zlib = require('zlib');
var UINT32 = require('cuint').UINT32;
var version = "006";
const VERSION_LENGTH = 3;
const APP_ID_LENGTH = 32;

const getVersion = () => {
    return "007"
}

class Service {
    constructor(service_type){
        this.__type = service_type
        this.__privileges = {}
    }

    __pack_type(){
        let buf = new ByteBuf()
        buf.putUint16(this.__type)
        return buf.pack()
    }

    __pack_privileges(){
        let buf = new ByteBuf()
        buf.putTreeMapUInt32(this.__privileges)
        return buf.pack()
    }

    add_privilege(privilege, expire){
        this.__privileges[privilege] = expire
    }
    pack(){
        return Buffer.concat([this.__pack_type(), this.__pack_privileges()])
    }
    unpack(buffer){
        let bufReader = new ReadByteBuf(buffer)
        return bufReader.getTreeMapUInt32()
    }
}

const kRtcServiceType = 1
class ServiceRtc extends Service{
    constructor(channel_name, uid) {
        super(kRtcServiceType)
        this.__channel_name = channel_name
        this.__uid = uid === 0 ? '' : `${uid}`
    }

    pack(){
        let buffer = new ByteBuf()
        buffer.putString(this.__channel_name).putString(this.__uid)
        return Buffer.concat([super.pack(),buffer.pack()])
    }

    unpack(){

    }
}
ServiceRtc.kPrivilegeJoinChannel = 1

class AccessToken2{
    constructor(appID, appCertificate, issue_ts, expire) {
        this.appID = appID
        this.appCertificate = appCertificate
        this.issue_ts = issue_ts || new Date().getTime()
        this.expire = expire
        // salt ranges in (1, 99999999)
        this.salt = Math.floor(Math.random() * (99999999)) + 1
        this.services = {}
    }

    __signing() {
        let signing = encodeHMac(this.appCertificate, new ByteBuf().putUint32(this.issue_ts).pack())
        signing = encodeHMac(signing, new ByteBuf().putUint32(this.salt).pack())
        return signing
    }

    __build_check() {
        let is_uuid = (data) => {
            if(data.length !== 32) {
                return false
            }
            let buf = Buffer.from(data, 'hex')
            return !!buf
        }

        const {appID, appCertificate, services} = this
        if(!is_uuid(appID) || !is_uuid(appCertificate)) {
            return false
        }

        if(Object.keys(services).length === 0){
            return false
        }
        return true
    }

    add_service(service){
        this.services[service.service_type] = service
    }

    build(){
        if(!this.__build_check()){
            return ""
        }

        let signing = this.__signing()
        let signing_info = new ByteBuf().putString(this.appID)
                .putUint32(this.issue_ts)
                .putUint32(this.expire)
                .putUint32(this.salt)
                .putUint16(Object.keys(this.services).length)
        Object.values(this.services).forEach(service => {
            signing_info.appendBytes(service.pack())
        })

        let signature = encodeHMac(signing, signing_info.pack())
        let compressed = zlib.deflateSync((new ByteBuf().putString(signature).appendBytes(signing_info.pack())).pack())
        return `${getVersion()}${Buffer.from(compressed).toString('base64')}`
    }

    from_string(origin_token) {
        let origin_version = origin_token.substring(0, VERSION_LENGTH)
        if(origin_version !== getVersion()){
            return false
        }

        let origin_content = origin_token.substring(VERSION_LENGTH, origin_token.length)
        let buffer = zlib.inflateSync(new Buffer(origin_content, 'base64'))
        let bufferReader = new ReadByteBuf(buffer)

        let signature = bufferReader.getString()
    }
}


var encodeHMac = function (key, message) {
    return crypto.createHmac('sha256', key).update(message).digest();
};

var ByteBuf = function () {
    var that = {
        buffer: Buffer.alloc(1024)
        , position: 0
    };

    that.buffer.fill(0);

    that.pack = function () {
        var out = Buffer.alloc(that.position);
        that.buffer.copy(out, 0, 0, out.length);
        return out;
    };

    that.putUint16 = function (v) {
        that.buffer.writeUInt16LE(v, that.position);
        that.position += 2;
        return that;
    };

    that.putUint32 = function (v) {
        that.buffer.writeUInt32LE(v, that.position);
        that.position += 4;
        return that;
    };

    that.putBytes = function (bytes) {
        that.putUint16(bytes.length);
        bytes.copy(that.buffer, that.position);
        that.position += bytes.length;
        return that;
    };

    that.appendBytes = function(bytes) {
        bytes.copy(that.buffer, that.position);
        that.position += bytes.length;
        return that;
    }

    that.putString = function (str) {
        return that.putBytes(Buffer.from(str));
    };

    that.putTreeMap = function (map) {
        if (!map) {
            that.putUint16(0);
            return that;
        }

        that.putUint16(Object.keys(map).length);
        for (var key in map) {
            that.putUint16(key);
            that.putString(map[key]);
        }

        return that;
    };

    that.putTreeMapUInt32 = function (map) {
        if (!map) {
            that.putUint16(0);
            return that;
        }

        that.putUint16(Object.keys(map).length);
        for (var key in map) {
            that.putUint16(key);
            that.putUint32(map[key]);
        }

        return that;
    };
    
    return that;
}


var ReadByteBuf = function(bytes) {
    var that = {
        buffer: bytes
        , position: 0
    };

    that.getUint16 = function () {
        var ret = that.buffer.readUInt16LE(that.position);
        that.position += 2;
        return ret;
    };

    that.getUint32 = function () {
        var ret = that.buffer.readUInt32LE(that.position);
        that.position += 4;
        return ret;
    };

    that.getString = function () {
        var len = that.getUint16();

        var out = Buffer.alloc(len);
        that.buffer.copy(out, 0, that.position, (that.position + len));
        that.position += len;
        return out;
    };

    that.getTreeMapUInt32 = function () {
        var map = {};
        var len = that.getUint16();
        for( var i = 0; i < len; i++) {
            var key = that.getUint16();
            var value = that.getUint32();
            map[key] = value;
        }
        return map;
    };

    return that;
}
var AccessTokenContent = function (options) {
    options.pack = function () {
        var out = new ByteBuf();
        return out.putString(options.signature)
            .putUint32(options.crc_channel)
            .putUint32(options.crc_uid)
            .putString(options.m).pack();
    }

    return options;
}

var Message = function (options) {
    options.pack = function () {
        var out = new ByteBuf();
        var val = out
            .putUint32(options.salt)
            .putUint32(options.ts)
            .putTreeMapUInt32(options.messages).pack();
        return val;
    }

    return options;
}

var unPackContent = function(bytes) {
    var readbuf = new ReadByteBuf(bytes);
    return AccessTokenContent({
        signature: readbuf.getString(),
        crc_channel_name: readbuf.getUint32(),
        crc_uid: readbuf.getUint32(),
        m: readbuf.getString()
    });
}

var unPackMessages = function(bytes) {
    var readbuf = new ReadByteBuf(bytes);
    return Message({
        salt: readbuf.getUint32(),
        ts: readbuf.getUint32(),
        messages: readbuf.getTreeMapUInt32()
    });
}


module.exports = {AccessToken2, ServiceRtc}