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

exports.buildUserToken_Test = function (test) {
    let token = ChatTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expire);
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(userUuid, accessToken.services[kChatServiceType].__user_id);
    test.equal(expire, accessToken.services[kChatServiceType].__privileges[ServiceChat.kPrivilegeUser]);
    test.done();
};

exports.buildAppToken_Test = function (test) {
	let token = ChatTokenBuilder.buildAppToken(appId, appCertificate, expire);
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(expire, accessToken.services[kChatServiceType].__privileges[ServiceChat.kPrivilegeApp]);
    test.done();
}

