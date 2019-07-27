var RtmTokenBuilder = require('../src/RtmTokenBuilder').RtmTokenBuilder;
var Priviledges = require('../src/AccessToken').priviledges;
var appID  = "970CA35de60c44645bbae8a215061b33";
var appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
var account = "test_user_id";
var expireTimestamp = Math.floor((+Date.now() + 3600) / 1000)

var builder = new RtmTokenBuilder(appID, appCertificate, account);
builder.setPrivilege(Priviledges.kRtmLogin, expireTimestamp);

var token = builder.buildToken();
console.log("Rtm Token: " + token);
