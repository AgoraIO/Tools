var crypto = require('crypto');

var version = "005";
var noUpload = "0";
var audioVideoUpload = "3";

var generatePublicSharingKey = function (appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs) {
    channelName=channelName.toString();
    return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, null, PUBLIC_SHARING_SERVICE);
};

var generateRecordingKey = function (appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs) {
    channelName=channelName.toString();
    return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, null, RECORDING_SERVICE);
};

var generateMediaChannelKey = function (appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs) {
    channelName=channelName.toString();
    return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, null, MEDIA_CHANNEL_SERVICE);
};

var generateInChannelPermissionKey = function (appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, permission) {
    var extra = {};
    extra[ALLOW_UPLOAD_IN_CHANNEL] = permission;
    return generateDynamicKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra, IN_CHANNEL_PERMISSION);
};

var generateDynamicKey = function (appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, extra, serviceType) {
    var signature = generateSignature5(appCertificate, serviceType, appID, unixTs, randomInt, channelName, uid, expiredTs, extra);
    var content = DynamicKey5Content({
        serviceType: serviceType
        , signature: signature
        , appID: hexDecode(appID)
        , unixTs: unixTs
        , salt: randomInt
        , expiredTs: expiredTs
        , extra: extra}).pack();
    return version + content.toString('base64');
};

module.exports.version = version;
module.exports.noUpload = noUpload;
module.exports.audioVideoUpload = audioVideoUpload;
module.exports.generatePublicSharingKey = generatePublicSharingKey;
module.exports.generateRecordingKey = generateRecordingKey;
module.exports.generateMediaChannelKey = generateMediaChannelKey;
module.exports.generateInChannelPermissionKey = generateInChannelPermissionKey;
module.exports.generateDynamicKey = generateDynamicKey;

var generateSignature5 = function(appCertificate, serviceType, appID, unixTs, randomInt, channelName, uid, expiredTs, extra) {
    // decode hex to avoid case problem
    var rawAppID = hexDecode(appID);
    var rawAppCertificate = hexDecode(appCertificate);

    var m = Message({
        serviceType: serviceType
        , appID: rawAppID
        , unixTs: unixTs
        , salt: randomInt
        , channelName: channelName
        , uid: uid
        , expiredTs: expiredTs
        , extra: extra
    });

    var toSign = m.pack();
    return encodeHMac(rawAppCertificate, toSign);
};

var encodeHMac = function(key, message) {
    return crypto.createHmac('sha1', key).update(message).digest('hex').toUpperCase();
};

var hexDecode = function(str) {
    return Buffer.from(str, 'hex');
};

var ByteBuf = function() {
    var that = {
        buffer: Buffer.alloc(1024)
        , position: 0
    };

    that.buffer.fill(0);

    that.pack = function() {
        var out = Buffer.alloc(that.position);
        that.buffer.copy(out, 0, 0, out.length);
        return out;
    };

    that.putUint16 = function(v) {
        that.buffer.writeUInt16LE(v, that.position);
        that.position += 2;
        return that;
    };

    that.putUint32 = function(v) {
        that.buffer.writeUInt32LE(v, that.position);
        that.position += 4;
        return that;
    };

    that.putBytes = function(bytes) {
        that.putUint16(bytes.length);
        bytes.copy(that.buffer, that.position);
        that.position += bytes.length;
        return that;
    };

    that.putString = function(str) {
        return that.putBytes(Buffer.from(str));
    };

    that.putTreeMap = function(map) {
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

    return that;
}

var DynamicKey5Content = function(options) {
    options.pack = function() {
        var out = ByteBuf();
        return out.putUint16(options.serviceType)
            .putString(options.signature)
            .putBytes(options.appID)
            .putUint32(options.unixTs)
            .putUint32(options.salt)
            .putUint32(options.expiredTs)
            .putTreeMap(options.extra)
            .pack();
    }

    return options;
}

var Message = function(options) {
    options.pack = function() {
        var out = ByteBuf();
        return out.putUint16(options.serviceType)
            .putBytes(options.appID)
            .putUint32(options.unixTs)
            .putUint32(options.salt)
            .putString(options.channelName)
            .putUint32(options.uid)
            .putUint32(options.expiredTs)
            .putTreeMap(options.extra)
            .pack();
    }

    return options;
}

// InChannelPermissionKey
var ALLOW_UPLOAD_IN_CHANNEL = 1;

// Service Type
var MEDIA_CHANNEL_SERVICE = 1;
var RECORDING_SERVICE = 2;
var PUBLIC_SHARING_SERVICE = 3;
var IN_CHANNEL_PERMISSION = 4;
