/**
 * run this test with command:
 * nodeunit DynamicKeyTest.js
 * see https://github.com/caolan/nodeunit
 */
var DynamicKey = require('../src/DynamicKey');
var DynamicKey3 = require('../src/DynamicKey3');
var DynamicKey4 = require('../src/DynamicKey4');
var DynamicKey5 = require('../src/DynamicKey5');

var appID  = "970ca35de60c44645bbae8a215061b33";
var appCertificate     = "5cfd2fd1755d40ecb72977518be15d3b";
var channel = "7d72365eb983485397e3e3f9d460bdda";
var ts = 1446455472;
var r = 58964981;
//var uid=999;
var uid=2882341273;
var expiredTs=1446455471;

exports.DynamicKey_Test = function (test) {
  var expected = "870588aad271ff47094eb622617e89d6b5b5a615970ca35de60c44645bbae8a215061b3314464554720383bbf5";
  var actual = DynamicKey.generate(appID, appCertificate, channel, ts, r);
  test.equal(expected, actual);
  test.done();
};

exports.DynamicKey3_Test = function (test) {
  var expected = "0037666966591a93ee5a3f712e22633f31f0cbc8f13970ca35de60c44645bbae8a215061b3314464554720383bbf528823412731446455471";
  var actual = DynamicKey3.generate(appID, appCertificate, channel, ts, r, uid, expiredTs);
  test.equal(expected, actual);
  test.done();
};

exports.PublicSharingKey4_Test = function (test) {
  var expected = "004ec32c0d528e58ef90e8ff437a9706124137dc795970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471";
  var actual = DynamicKey4.generatePublicSharingKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
  test.equal(expected, actual);
  test.done();
};

exports.RecordingKey4_Test = function (test) {
  var expected = "004e0c24ac56aae05229a6d9389860a1a0e25e56da8970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471";
  var actual = DynamicKey4.generateRecordingKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
  test.equal(expected, actual);
  test.done();
};

exports.MediaChannelKey4_Test = function (test) {
  console.log("MediaChannelKey4_Test");
  var expected = "004d0ec5ee3179c964fe7c0485c045541de6bff332b970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471";
  var actual = DynamicKey4.generateMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
  test.equal(expected, actual);
  test.done();
};

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
