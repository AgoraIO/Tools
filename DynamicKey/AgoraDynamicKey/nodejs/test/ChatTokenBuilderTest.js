/**
 * run this test with command:
 * nodeunit ChatTokenBuilderTest.js
 * see https://github.com/caolan/nodeunit
 */
const ChatTokenBuilder = require("../src/ChatTokenBuilder").ChatTokenBuilder;
const { AccessToken2, ServiceChat, kChatServiceType } = require("../src/AccessToken2");

const appId = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const userUuid = "2882341273";
const expire = 600;

// Verifies Chat user token generation and parsing.
exports.buildUserToken_Test = function (test) {
    let token = ChatTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expire);
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    const service = accessToken.getServices(kChatServiceType)[0];
    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(userUuid, service.__user_id);
    test.equal(expire, service.__privileges[ServiceChat.kPrivilegeUser]);
    test.done();
};

// Verifies Chat application token generation and parsing.
exports.buildAppToken_Test = function (test) {
	let token = ChatTokenBuilder.buildAppToken(appId, appCertificate, expire);
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(expire, accessToken.getServices(kChatServiceType)[0].__privileges[ServiceChat.kPrivilegeApp]);
    test.done();
}
