/**
 * run this test with command:
 * nodeunit test/RtcTokenBuilder2Test.js
 * see https://github.com/caolan/nodeunit
 */
import { RtcTokenBuilder, Role } from "../src/RtcTokenBuilder2.js";
import {AccessToken2, ServiceRtc, kRtcServiceType} from "../src/AccessToken2.js"
import {assert, assertThrows} from "https://deno.land/std/testing/asserts.ts";

const appId = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const channelName = "7d72365eb983485397e3e3f9d460bdda";
const uid = 2882341273;
const uidStr = "2882341273";
const expire = 600;

const tokenExpirationInSecond = 600;
const privilegeExpirationInSecond = 600;

Deno.test('buildTokenWithUid_SUBSCRIBER_Test', (test) => {
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

    assert(appId === accessToken.appId);
    assert(expire === accessToken.expire);
    assert(channelName === accessToken.services[kRtcServiceType].__channel_name);
    assert(uidStr === accessToken.services[kRtcServiceType].__uid);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegeJoinChannel]);
})

Deno.test('buildTokenWithUid_PUBLISHER_Test', (test) => {
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

    assert(appId === accessToken.appId);
    assert(expire === accessToken.expire);
    assert(channelName === accessToken.services[kRtcServiceType].__channel_name);
    assert(uidStr === accessToken.services[kRtcServiceType].__uid);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegeJoinChannel]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishAudioStream]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishVideoStream]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishDataStream]);
})

Deno.test('buildTokenWithUserAccount_SUBSCRIBER_Test', (test) => {
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

    assert(appId === accessToken.appId);
    assert(expire === accessToken.expire);
    assert(channelName === accessToken.services[kRtcServiceType].__channel_name);
    assert(uidStr === accessToken.services[kRtcServiceType].__uid);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegeJoinChannel]);
})

Deno.test('buildTokenWithUserAccount_PUBLISHER_Test', (test) => {
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

    assert(appId === accessToken.appId);
    assert(expire === accessToken.expire);
    assert(channelName === accessToken.services[kRtcServiceType].__channel_name);
    assert(uidStr === accessToken.services[kRtcServiceType].__uid);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegeJoinChannel]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishAudioStream]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishVideoStream]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishDataStream]);
})

Deno.test('buildTokenWithUidAndPrivilege_Test', (test) => {
    let token = RtcTokenBuilder.buildTokenWithUidAndPrivilege(appId, appCertificate, channelName, uid, expire, expire, expire, expire, expire);
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);

    assert(appId === accessToken.appId);
    assert(expire === accessToken.expire);
    assert(channelName === accessToken.services[kRtcServiceType].__channel_name);
    assert(uidStr === accessToken.services[kRtcServiceType].__uid);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegeJoinChannel]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishAudioStream]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishVideoStream]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishDataStream]);
})

Deno.test('BuildTokenWithUserAccountAndPrivilege_Test', (test) => {
    let token = RtcTokenBuilder.BuildTokenWithUserAccountAndPrivilege(appId, appCertificate, channelName, uidStr, expire, expire, expire, expire, expire);
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);

    assert(appId === accessToken.appId);
    assert(expire === accessToken.expire);
    assert(channelName === accessToken.services[kRtcServiceType].__channel_name);
    assert(uidStr === accessToken.services[kRtcServiceType].__uid);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegeJoinChannel]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishAudioStream]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishVideoStream]);
    assert(expire === accessToken.services[kRtcServiceType].__privileges[ServiceRtc.kPrivilegePublishDataStream]);
})
