/**
 * run this test with command:
 * nodeunit AccessTokenTest.js
 * see https://github.com/caolan/nodeunit
 */
const AccessToken = require("../src/AccessToken").AccessToken;
const Priviledges = require("../src/AccessToken").priviledges;

const appID = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const channel = "7d72365eb983485397e3e3f9d460bdda";
const uid = 2882341273;
const salt = 1;
const ts = 1111111;
const expireTimestamp = 1446455471;

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

// test uid = 0
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
