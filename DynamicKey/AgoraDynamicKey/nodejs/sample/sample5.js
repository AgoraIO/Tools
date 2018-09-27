var DynamicKey5 = require('../src/DynamicKey5');
var appID  = "970ca35de60c44645bbae8a215061b33";
var appCertificate     = "5cfd2fd1755d40ecb72977518be15d3b";
var channel = "my channel name";
var ts = Math.floor(new Date() / 1000);
var r = Math.floor(Math.random() * 0xFFFFFFFF);
var uid = 2882341273;
var expiredTs = 0;

console.log("5 recording key: " + DynamicKey5.generateRecordingKey(appID, appCertificate, channel, ts, r, uid, expiredTs));
console.log("5 channel key: " + DynamicKey5.generateMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs));
console.log("5 in channel permission key(no upload): "
    + DynamicKey5.generateInChannelPermissionKey(appID, appCertificate, channel, ts, r, uid, expiredTs, DynamicKey5.noUpload));
console.log("5 in channel permission key(audio video upload): "
    + DynamicKey5.generateInChannelPermissionKey(appID, appCertificate, channel, ts, r, uid, expiredTs, DynamicKey5.audioVideoUpload));
