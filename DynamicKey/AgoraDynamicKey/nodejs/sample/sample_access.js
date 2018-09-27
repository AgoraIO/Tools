var AccessToken = require('../src/AccessToken').AccessToken;
var Priviledges = require('../src/AccessToken').priviledges;
var appID  = "970CA35de60c44645bbae8a215061b33";
var appCertificate     = "5CFd2fd1755d40ecb72977518be15d3b";
var channel = "7d72365eb983485397e3e3f9d460bdda";
var uid = 2882341273;
var expireTimestamp = 0;

var key = new AccessToken(appID, appCertificate, channel, uid);
key.addPriviledge(Priviledges.kJoinChannel, expireTimestamp);

var token = key.build();
console.log(token);
