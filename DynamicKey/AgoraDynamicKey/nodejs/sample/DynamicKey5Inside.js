var crypto = require('crypto');

var appID  = "970ca35de60c44645bbae8a215061b33";
var appCertificate = "5cfd2fd1755d40ecb72977518be15d3b";
var channel = "7d72365eb983485397e3e3f9d460bdda";
var ts = 1446455472;
var r = 58964981;
var uid=2882341273;
var expiredTs=1446455471;

var version = "005";
var noUpload = "0";
var audioVideoUpload = "3";

var encodeHMac = function(key, message) {
    return crypto.createHmac('sha1', key).update(message).digest('hex').toUpperCase();
};

var hexDecode = function(str) {
    return new Buffer(str, 'hex');
};

var ByteBuf = function() {
    var that = {
        buffer: new Buffer(1024)
        , position: 0
    };

    that.buffer.fill(0);

    that.pack = function() {
        var out = new Buffer(that.position);
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
        return that.putBytes(new Buffer(str));
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

var inspectMediaChannelKey = function (appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs) {
    var rawAppID = hexDecode(appID);
    console.log('App ID:\t\t\t ' + rawAppID.toString('hex').toUpperCase());

    var rawAppCertificate = hexDecode(appCertificate);
    console.log('App Certificate:\t ' + rawAppCertificate.toString('hex').toUpperCase());

    var serviceType = MEDIA_CHANNEL_SERVICE;
    var extra = null;

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
    console.log("Message to sign:\t " + toSign.toString('hex').toUpperCase());

    var signature = encodeHMac(rawAppCertificate, toSign);
    console.log("Signature:\t\t " + signature.toString('hex').toUpperCase());

    var content = DynamicKey5Content({
        serviceType: serviceType
        , signature: signature
        , appID: hexDecode(appID)
        , unixTs: unixTs
        , salt: randomInt
        , expiredTs: expiredTs
        , extra: extra}).pack();
    console.log("Content to encode:\t " + content.toString('hex').toUpperCase());

    var channelKey = version + content.toString('base64');
    console.log("Channel key:\t\t " + channelKey);
    return channelKey;
};

var expected = "005AQAoAEJERTJDRDdFNkZDNkU0ODYxNkYxQTYwOUVFNTM1M0U5ODNCQjFDNDQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==";
var result = inspectMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
console.log( (expected == result) ? "ok" : "failed");
