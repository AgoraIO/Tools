/**
 * run this test with command:
 * nodeunit test/RtcTokenBuilder2Test.js
 * see https://github.com/caolan/nodeunit
 */
const RtcTokenBuilder = require("../src/RtcTokenBuilder2").RtcTokenBuilder;
const Role = require("../src/RtcTokenBuilder2").Role;
const { AccessToken2, ServiceRtc, kRtcServiceType } = require("../src/AccessToken2");

const appId = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const channelName = "7d72365eb983485397e3e3f9d460bdda";
const uid = 2882341273;
const uidStr = "2882341273";
const expire = 600;

const tokenExpirationInSecond = 600;
const privilegeExpirationInSecond = 600;

// Verifies subscriber RTC token generation with a numeric user ID.
exports.buildTokenWithUid_SUBSCRIBER_Test = function (test) {
    let token = RtcTokenBuilder.buildTokenWithUid(
        appId,
        appCertificate,
        channelName,
        uid,
        Role.SUBSCRIBER,
        tokenExpirationInSecond,
        privilegeExpirationInSecond
    );
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    const service = accessToken.getServices(kRtcServiceType)[0];

    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(channelName, service.__channel_name);
    test.equal(uidStr, service.__uid);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegeJoinChannel]);
    test.done();
};

// Verifies publisher RTC token generation with a numeric user ID.
exports.buildTokenWithUid_PUBLISHER_Test = function (test) {
    let token = RtcTokenBuilder.buildTokenWithUid(
        appId,
        appCertificate,
        channelName,
        uid,
        Role.PUBLISHER,
        tokenExpirationInSecond,
        privilegeExpirationInSecond
    );
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    const service = accessToken.getServices(kRtcServiceType)[0];

    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(channelName, service.__channel_name);
    test.equal(uidStr, service.__uid);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegeJoinChannel]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishAudioStream]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishVideoStream]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishDataStream]);
    test.done();
};

// Verifies subscriber RTC token generation with a user account.
exports.buildTokenWithUserAccount_SUBSCRIBER_Test = function (test) {
    let token = RtcTokenBuilder.buildTokenWithUserAccount(
        appId,
        appCertificate,
        channelName,
        uidStr,
        Role.SUBSCRIBER,
        tokenExpirationInSecond,
        privilegeExpirationInSecond
    );
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    const service = accessToken.getServices(kRtcServiceType)[0];

    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(channelName, service.__channel_name);
    test.equal(uidStr, service.__uid);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegeJoinChannel]);
    test.done();
};

// Verifies publisher RTC token generation with a user account.
exports.buildTokenWithUserAccount_PUBLISHER_Test = function (test) {
    let token = RtcTokenBuilder.buildTokenWithUserAccount(
        appId,
        appCertificate,
        channelName,
        uid,
        Role.PUBLISHER,
        tokenExpirationInSecond,
        privilegeExpirationInSecond
    );
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    const service = accessToken.getServices(kRtcServiceType)[0];

    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(channelName, service.__channel_name);
    test.equal(uidStr, service.__uid);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegeJoinChannel]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishAudioStream]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishVideoStream]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishDataStream]);
    test.done();
};

// Verifies RTC token generation with explicit numeric-user privileges.
exports.buildTokenWithUidAndPrivilege_Test = function (test) {
    let token = RtcTokenBuilder.buildTokenWithUidAndPrivilege(appId, appCertificate, channelName, uid, expire, expire, expire, expire, expire);
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    const service = accessToken.getServices(kRtcServiceType)[0];

    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(channelName, service.__channel_name);
    test.equal(uidStr, service.__uid);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegeJoinChannel]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishAudioStream]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishVideoStream]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishDataStream]);
    test.done();
};

// Verifies RTC token generation with explicit user-account privileges.
exports.BuildTokenWithUserAccountAndPrivilege_Test = function (test) {
    let token = RtcTokenBuilder.BuildTokenWithUserAccountAndPrivilege(appId, appCertificate, channelName, uidStr, expire, expire, expire, expire, expire);
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);
    const service = accessToken.getServices(kRtcServiceType)[0];

    test.equal(appId, accessToken.appId);
    test.equal(expire, accessToken.expire);
    test.equal(channelName, service.__channel_name);
    test.equal(uidStr, service.__uid);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegeJoinChannel]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishAudioStream]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishVideoStream]);
    test.equal(expire, service.__privileges[ServiceRtc.kPrivilegePublishDataStream]);
    test.done();
};
