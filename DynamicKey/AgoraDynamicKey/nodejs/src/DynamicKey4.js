/**
* Server side. Generate Client key.
*/

var crypto = require('crypto');

module.exports.generatePublicSharingKey = function (appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs) {
  channelName=channelName.toString();
  return doGenerate(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, 'APSS');
}

module.exports.generateRecordingKey = function (appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs) {
  channelName=channelName.toString();
  return doGenerate(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, 'ARS');
}

module.exports.generateMediaChannelKey = function (appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs) {
  channelName=channelName.toString();
  return doGenerate(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, 'ACS');
}

function doGenerate(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, serviceType) {
    uid=(new Uint32Array([uid]))[0]
    var version = "004";
    var unixTsStr = unixTs.toString();  //Unix Time stamp, track time as a running total of seconds
    var rndTxt = randomInt.toString(16);
    var randomIntStr = ("00000000" + rndTxt).substring(rndTxt.length);
    var expiredTsStr = ("0000000000" + expiredTs).substring(String(expiredTs).length);
    var uidStr = ("0000000000" + uid).substring(String(uid).length);
    var sign = generateSignature4(appID, appCertificate, channelName, unixTsStr, randomIntStr, uidStr, expiredTsStr, serviceType);
    return version + sign + appID + unixTsStr + randomIntStr+ expiredTsStr;
};

var generateSignature4 = function(appID, appCertificate, channelName, unixTsStr, randomIntStr,uidStr, expiredTsStr, serviceType) {
    var buffer = Buffer.concat([new Buffer(serviceType), new Buffer(appID), new Buffer(unixTsStr), new Buffer(randomIntStr), new Buffer(channelName), new Buffer(uidStr), new Buffer(expiredTsStr)]);
    var sign = encodeHMac(appCertificate, buffer);
    return sign.toString('hex');
};

var encodeHMac = function(key, message) {
    return crypto.createHmac('sha1', key).update(message).digest('hex');
};
