/**
 * run this test with command:
 * nodeunit AccessTokenTest.js
 * see https://github.com/caolan/nodeunit
 */
var AccessToken = require('../src/AccessToken');
var SimpleTokenBuilder = require('../src/SimpleTokenBuilder');
var Role = require('../src/SimpleTokenBuilder').Role;
var Priviledges = require('../src/AccessToken').priviledges;

var appID = "970CA35de60c44645bbae8a215061b33";
var appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
var channel = "7d72365eb983485397e3e3f9d460bdda";
var uid = 2882341273;
var salt = 1;
var ts = 1111111;
var expireTimestamp = 1446455471;

exports.AccessToken_Test = function (test) {
  var expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";

  var key = new AccessToken.AccessToken(appID, appCertificate, channel, uid);
  key.salt = salt;
  key.ts = ts;
  key.messages[Priviledges.kJoinChannel] = expireTimestamp;

  var actual = key.build();
  test.equal(expected, actual);
  test.done();
};

// test uid = 0
exports.AccessToken_Test2 = function (test) {
  var expected = "006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW";

  var uid_zero = 0;
  var key = new AccessToken.AccessToken(appID, appCertificate, channel, uid_zero);
  key.salt = salt;
  key.ts = ts;
  key.messages[Priviledges.kJoinChannel] = expireTimestamp;

  var actual = key.build();
  test.equal(expected, actual);
  test.done();
};

exports.SimpleTokenBuilder_Test = function (test) {
  var expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";

  var builder = new SimpleTokenBuilder.SimpleTokenBuilder(appID, appCertificate, channel, uid);
  builder.key.salt = salt;
  builder.key.ts = ts;
  builder.key.messages[Priviledges.kJoinChannel] = expireTimestamp;

  var actual = builder.buildToken();
  test.equal(expected, actual);
  test.done();
};

