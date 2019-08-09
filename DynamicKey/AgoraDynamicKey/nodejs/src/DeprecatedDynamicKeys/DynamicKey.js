/**
* Server side. Generate Client key.
*/

var crypto = require('crypto');

var encodeHMac = function(key, message) {
    return crypto.createHmac('sha1', key).update(message).digest('hex');
};

module.exports.generate = function(appID, appCertificate, channelName, unixTs, randomInt) {
    channelName=channelName.toString();
    var unixTsStr = ("0000000000" + unixTs).substring(String(unixTs).length);
    var rndTxt = randomInt.toString(16);
    var randomIntStr = ("00000000" + rndTxt).substring(rndTxt.length);
    var sign = generateSignature(appID, appCertificate, channelName, unixTsStr, randomIntStr);
    return sign + appID + unixTsStr + randomIntStr;
};

var generateSignature = function(appID, appCertificate, channelName, unixTsStr, randomIntStr) {
    var buffer = Buffer.concat([new Buffer(appID), new Buffer(unixTsStr), new Buffer(randomIntStr), new Buffer(channelName)]);
    var sign = encodeHMac(appCertificate, buffer);
    return sign.toString('hex');
};
