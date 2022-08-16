/**
 * run this test with command:
 * nodeunit AccessTokenTest.js
 * see https://github.com/caolan/nodeunit
 */
const AccessToken = require("../src/AccessToken").AccessToken;
const RtmTokenBuilder = require("../src/RtmTokenBuilder").RtmTokenBuilder;
const Role = require("../src/RtmTokenBuilder").Role;
const Priviledges = require("../src/AccessToken").priviledges;

const appID = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const account = "test_user";
const expireTimestamp = 1446455471;

exports.RtmToken_Test = function (test) {
    const token = RtmTokenBuilder.buildToken(appID, appCertificate, account, Role.Rtm_User, expireTimestamp);
    let accessToken = new AccessToken("", "", 0, 0);
    accessToken.fromString(token);

    test.equal(appID, accessToken.appID);
    test.equal(expireTimestamp, accessToken.messages[Priviledges.kRtmLogin]);
    test.done();
};
