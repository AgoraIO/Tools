/**
 * run this test with command:
 * nodeunit test/RtmTokenBuilder2Test.js
 * see https://github.com/caolan/nodeunit
 */
const RtmTokenBuilder = require("../src/RtmTokenBuilder2").RtmTokenBuilder;
const { AccessToken2, ServiceRtm, kRtmServiceType } = require("../src/AccessToken2");

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
