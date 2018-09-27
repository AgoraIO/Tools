var SimpleTokenBuilder = require('../src/SimpleTokenBuilder').SimpleTokenBuilder;
var Role = require('../src/SimpleTokenBuilder').Role;
var Priviledges = require('../src/AccessToken').priviledges;
var appID  = "970CA35de60c44645bbae8a215061b33";
var appCertificate     = "5CFd2fd1755d40ecb72977518be15d3b";
var channel = "7d72365eb983485397e3e3f9d460bdda";
var uid = 2882341273;
var expireTimestamp = 0;

var builder = new SimpleTokenBuilder(appID, appCertificate, channel, uid);

builder.initPrivileges(Role.kRoleAttendee);
builder.setPrivilege(Priviledges.kJoinChannel, expireTimestamp);
builder.setPrivilege(Priviledges.kPublishAudioStream, expireTimestamp);
builder.setPrivilege(Priviledges.kPublishVideoStream, expireTimestamp);
builder.setPrivilege(Priviledges.kPublishDataStream, expireTimestamp);

var token = builder.buildToken();
console.log(token);
