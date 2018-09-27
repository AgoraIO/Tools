var DynamicKey4 = require('../src/DynamicKey4');
var appID  = "970ca35de60c44645bbae8a215061b33";
var appCertificate     = "5cfd2fd1755d40ecb72977518be15d3b";
var channel = "my channel name";
var ts = Math.floor(new Date() / 1000);
var r = Math.floor(Math.random() * 0xFFFFFFFF);
var uid = 2882341273;
var expiredTs = 0;

console.log("4 recording key: " + DynamicKey4.generateRecordingKey(appID, appCertificate, channel, ts, r, uid, expiredTs));
console.log("4 channel key: " + DynamicKey4.generateMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs));
