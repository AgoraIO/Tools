/**
 * run this test with command:
 * nodeunit AccessTokenTest.js
 * see https://github.com/caolan/nodeunit
 */
const AccessToken = require("../src/AccessToken").AccessToken;
const Priviledges = require("../src/AccessToken").priviledges;
const RtcTokenBuilder = require('../src/RtcTokenBuilder').RtcTokenBuilder;
const SignalingToken = require('../src/SignalingToken');
const fs = require('fs');
const path = require('path');
const Module = require('module');

const appID = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const channel = "7d72365eb983485397e3e3f9d460bdda";
const uid = 2882341273;
const salt = 1;
const ts = 1111111;
const expireTimestamp = 1446455471;

// Verifies deterministic legacy AccessToken generation.
exports.AccessToken_Test = function (test) {
    const expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";

    const key = new AccessToken(appID, appCertificate, channel, uid);
    key.salt = salt;
    key.ts = ts;
    key.messages[Priviledges.kJoinChannel] = expireTimestamp;

    const actual = key.build();
    test.equal(expected, actual);
    test.done();
};

// Verifies deterministic legacy AccessToken generation with an empty user ID.
exports.AccessToken_Test2 = function (test) {
    const expected = "006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW";

    const uid_zero = 0;
    const key = new AccessToken(appID, appCertificate, channel, uid_zero);
    key.salt = salt;
    key.ts = ts;
    key.messages[Priviledges.kJoinChannel] = expireTimestamp;

    const actual = key.build();
    test.equal(expected, actual);
    test.done();
};

const RtcRole = require("../src/RtcTokenBuilder").Role;

// Verifies deterministic legacy RTC token generation.
exports.RtcTokenBuilder_Test = function (test) {
    const appID = "970CA35de60c44645bbae8a215061b33";
    const certificate = "5CFd2fd1755d40ecb72977518be15d3b";
    const expected =
        "006970CA35de60c44645bbae8a215061b33IACMv3I+fsRSejxy6luEwzA/1t/zbEHWfJCJ5m8ssFP/fLdIfRBXoFHlIgABAAAAR/QQAAQAAQCvKDdWAgCvKDdWAwCvKDdWBACvKDdW";

    const channelName = "7d72365eb983485397e3e3f9d460bdda";

    const uid = 2882341273;

    const salt = 1;

    const ts = 1111111;

    const privilegeExpiredsTs = 1446455471;

    const role = RtcRole.PUBLISHER;

    const key = new AccessToken(appID, certificate, channelName, uid);
    key.addPriviledge(Priviledges.kJoinChannel, privilegeExpiredsTs);
    key.salt = salt;
    key.ts = ts;
    if (role == RtcRole.PUBLISHER || role == RtcRole.SUBSCRIBER || role == RtcRole.ADMIN) {
        key.addPriviledge(Priviledges.kPublishAudioStream, privilegeExpiredsTs);
        key.addPriviledge(Priviledges.kPublishVideoStream, privilegeExpiredsTs);
        key.addPriviledge(Priviledges.kPublishDataStream, privilegeExpiredsTs);
    }
    const actual = key.build();
    test.equal(expected, actual);
    test.done();
};

// Verifies legacy token parsing and malformed input handling.
exports.AccessToken_Parse_Test = function (test) {
    const key = new AccessToken(appID, appCertificate, channel, uid);
    key.salt = salt;
    key.ts = ts;
    key.addPriviledge(Priviledges.kJoinChannel, expireTimestamp);

    const parsed = new AccessToken('', '', '', '');
    test.equal(true, parsed.fromString(key.build()));
    test.equal(expireTimestamp, parsed.messages[Priviledges.kJoinChannel]);
    test.equal(false, parsed.fromString('007invalid'));
    test.equal(false, parsed.fromString('006' + appID + '!'));
    test.done();
};

// Verifies both public legacy RTC builder entry points.
exports.RtcTokenBuilder_PublicMethods_Test = function (test) {
    const uidToken = RtcTokenBuilder.buildTokenWithUid(
        appID, appCertificate, channel, uid, RtcRole.PUBLISHER, expireTimestamp);
    const accountToken = RtcTokenBuilder.buildTokenWithAccount(
        appID, appCertificate, channel, String(uid), RtcRole.SUBSCRIBER, expireTimestamp);

    test.equal(true, new AccessToken('', '', '', '').fromString(uidToken));
    test.equal(true, new AccessToken('', '', '', '').fromString(accountToken));
    test.done();
};

// Verifies signaling token generation for explicit and one-day lifetimes.
exports.SignalingToken_Test = function (test) {
    const token = SignalingToken.get(appID, appCertificate, String(uid), 60);
    const oneDayToken = SignalingToken.get1DayToken(appID, appCertificate, String(uid));

    test.equal(4, token.split(':').length);
    test.equal(appID, token.split(':')[1]);
    test.equal(4, oneDayToken.split(':').length);
    test.done();
};

// Exercises legacy private map writers retained by the Token006 wire format.
exports.AccessToken_BufferHelpers_Test = function (test) {
    const filename = path.resolve(__dirname, '../src/AccessToken.js');
    const source = fs.readFileSync(filename, 'utf8') + '\nmodule.exports.__ByteBuf = ByteBuf;';
    const internalModule = new Module(filename, module);
    internalModule.filename = filename;
    internalModule.paths = Module._nodeModulePaths(path.dirname(filename));
    internalModule._compile(source, filename);
    const ByteBuf = internalModule.exports.__ByteBuf;

    test.equal(2, new ByteBuf().putTreeMap(null).pack().length);
    test.ok(new ByteBuf().putTreeMap({ 1: 'value' }).pack().length > 2);
    test.equal(2, new ByteBuf().putTreeMapUInt32(null).pack().length);
    test.done();
};
