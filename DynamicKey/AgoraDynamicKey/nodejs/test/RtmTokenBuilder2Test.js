/**
 * run this test with command:
 * nodeunit test/RtmTokenBuilder2Test.js
 * see https://github.com/caolan/nodeunit
 */
const { Rtm2Permissions, RtmTokenBuilder } = require("../index");
const { AccessToken2, ServiceRtm, ServiceRtm2, kRtmServiceType, kRtm2ServiceType } = require("../src/AccessToken2");

const appId = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const userId = "test_user";
const expire = 600;

// Verifies RTM Token007 generation and parsing.
exports.buildToken = function (test) {
    let token = RtmTokenBuilder.buildToken(appId, appCertificate, userId, expire);
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    const service = accessToken.getServices(kRtmServiceType)[0];

    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(userId, service.__user_id);
    test.equal(expire, service.__privileges[ServiceRtm.kPrivilegeLogin]);
    test.done();
};

// Verifies RTM2 permission token generation, parsing, and signature validation.
exports.buildTokenWithPermissions = function (test) {
    const permissions = new Rtm2Permissions();
    permissions.add(Rtm2Permissions.kMessageChannels, Rtm2Permissions.kRead, ["message-a", "message-b"]);
    permissions.add(Rtm2Permissions.kStreamChannels, Rtm2Permissions.kWrite, ["stream-a"]);

    const token = RtmTokenBuilder.buildTokenWithPermissions(appId, appCertificate, userId, permissions, expire);
    const parsed = new AccessToken2("", "", 0, 0);

    test.equal(true, parsed.from_string(token));
    test.equal(true, parsed.verifySignature(appCertificate));
    const service = parsed.getServices(kRtm2ServiceType)[0];
    test.equal(userId, service.__user_id.toString());
    test.deepEqual(permissions.details, service.__permissions.details);
    test.equal(expire, service.__privileges[ServiceRtm2.kPrivilegeLogin]);
    test.done();
};
