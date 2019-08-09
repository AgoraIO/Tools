/**
 * run this test with command:
 * nodeunit DynamicKeyTest.js
 * see https://github.com/caolan/nodeunit
 */
var DynamicKey5 = require('../src/DynamicKey5');

var appID  = "970ca35de60c44645bbae8a215061b33";
var appCertificate     = "5cfd2fd1755d40ecb72977518be15d3b";
var channel = "7d72365eb983485397e3e3f9d460bdda";
var ts = 1446455472;
var r = 58964981;
//var uid=999;
var uid=2882341273;
var expiredTs=1446455471;

exports.PublicSharingKey5_Test = function(test) {
  var expected = "005AwAoADc0QTk5RTVEQjI4MDk0NUI0NzUwNTk0MUFDMjM4MDU2NzIwREY3QjAQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==";
  var actual = DynamicKey5.generatePublicSharingKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
  test.equal(expected, actual);
  test.done();
};

exports.RecordingKey5_Test = function(test) {
  var expected = "005AgAoADkyOUM5RTQ2MTg3QTAyMkJBQUIyNkI3QkYwMTg0MzhDNjc1Q0ZFMUEQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==";
  var result = DynamicKey5.generateRecordingKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
  test.equal(expected, result);
  test.done();
};

exports.MediaChannelKey5_Test = function(test) {
  var expected = "005AQAoAEJERTJDRDdFNkZDNkU0ODYxNkYxQTYwOUVFNTM1M0U5ODNCQjFDNDQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==";
  var result = DynamicKey5.generateMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
  test.equal(expected, result);
  test.done();
};

exports.InChannelPermission5_Test = function(test) {
  var noUpload = "005BAAoADgyNEQxNDE4M0FGRDkyOEQ4REFFMUU1OTg5NTg2MzA3MTEyNjRGNzQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAw";
  var generatedNoUpload = DynamicKey5.generateInChannelPermissionKey(appID, appCertificate, channel, ts, r, uid, expiredTs, DynamicKey5.noUpload);
  test.equal(noUpload, generatedNoUpload);

  var audioVideoUpload = "005BAAoADJERDA3QThENTE2NzJGNjQwMzY5NTFBNzE0QkI5NTc0N0Q1QjZGQjMQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAz";
  var generatedAudioVideoUpload = DynamicKey5.generateInChannelPermissionKey(appID, appCertificate, channel, ts, r, uid, expiredTs, DynamicKey5.audioVideoUpload);
  test.equal(audioVideoUpload, generatedAudioVideoUpload);
  test.done();
};
