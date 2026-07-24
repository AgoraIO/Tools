/**
 * run this test with command:
 * deno test test/RtcTokenBuilder2Test.js
 */
import { Role, RtcTokenBuilder } from '../src/RtcTokenBuilder2.js'
import { AccessToken2, kRtcServiceType, kRtmServiceType, ServiceRtc, ServiceRtm } from '../src/AccessToken2.js'
import { assert, assertThrows } from 'https://deno.land/std/testing/asserts.ts'

const appId = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const channelName = '7d72365eb983485397e3e3f9d460bdda'
const uid = 2882341273
const uidStr = '2882341273'
const expire = 600

const tokenExpirationInSecond = 600
const privilegeExpirationInSecond = 600

// Verifies subscriber RTC token generation with a numeric user ID.
Deno.test('buildTokenWithUid_SUBSCRIBER_Test', () => {
    let token = RtcTokenBuilder.buildTokenWithUid(
        appId,
        appCertificate,
        channelName,
        uid,
        Role.SUBSCRIBER,
        tokenExpirationInSecond,
        privilegeExpirationInSecond,
    )
    let accessToken = new AccessToken2('', '', 0, 0)
    accessToken.from_string(token)
    const service = accessToken.getServices(kRtcServiceType)[0]

    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
    assert(channelName === service.__channel_name)
    assert(uidStr === service.__uid)
    assert(expire === service.__privileges[ServiceRtc.kPrivilegeJoinChannel])
})

// Verifies publisher RTC token generation with a numeric user ID.
Deno.test('buildTokenWithUid_PUBLISHER_Test', () => {
    let token = RtcTokenBuilder.buildTokenWithUid(
        appId,
        appCertificate,
        channelName,
        uid,
        Role.PUBLISHER,
        tokenExpirationInSecond,
        privilegeExpirationInSecond,
    )
    let accessToken = new AccessToken2('', '', 0, 0)
    accessToken.from_string(token)
    const service = accessToken.getServices(kRtcServiceType)[0]

    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
    assert(channelName === service.__channel_name)
    assert(uidStr === service.__uid)
    assert(expire === service.__privileges[ServiceRtc.kPrivilegeJoinChannel])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishAudioStream])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishVideoStream])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishDataStream])
})

// Verifies subscriber RTC token generation with a user account.
Deno.test('buildTokenWithUserAccount_SUBSCRIBER_Test', () => {
    let token = RtcTokenBuilder.buildTokenWithUserAccount(
        appId,
        appCertificate,
        channelName,
        uidStr,
        Role.SUBSCRIBER,
        tokenExpirationInSecond,
        privilegeExpirationInSecond,
    )
    let accessToken = new AccessToken2('', '', 0, 0)
    accessToken.from_string(token)
    const service = accessToken.getServices(kRtcServiceType)[0]

    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
    assert(channelName === service.__channel_name)
    assert(uidStr === service.__uid)
    assert(expire === service.__privileges[ServiceRtc.kPrivilegeJoinChannel])
})

// Verifies publisher RTC token generation with a user account.
Deno.test('buildTokenWithUserAccount_PUBLISHER_Test', () => {
    let token = RtcTokenBuilder.buildTokenWithUserAccount(
        appId,
        appCertificate,
        channelName,
        uid,
        Role.PUBLISHER,
        tokenExpirationInSecond,
        privilegeExpirationInSecond,
    )
    let accessToken = new AccessToken2('', '', 0, 0)
    accessToken.from_string(token)
    const service = accessToken.getServices(kRtcServiceType)[0]

    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
    assert(channelName === service.__channel_name)
    assert(uidStr === service.__uid)
    assert(expire === service.__privileges[ServiceRtc.kPrivilegeJoinChannel])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishAudioStream])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishVideoStream])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishDataStream])
})

// Verifies RTC token generation with explicit numeric-user privileges.
Deno.test('buildTokenWithUidAndPrivilege_Test', () => {
    let token = RtcTokenBuilder.buildTokenWithUidAndPrivilege(appId, appCertificate, channelName, uid, expire, expire, expire, expire, expire)
    let accessToken = new AccessToken2('', '', 0, 0)
    accessToken.from_string(token)
    const service = accessToken.getServices(kRtcServiceType)[0]

    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
    assert(channelName === service.__channel_name)
    assert(uidStr === service.__uid)
    assert(expire === service.__privileges[ServiceRtc.kPrivilegeJoinChannel])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishAudioStream])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishVideoStream])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishDataStream])
})

// Verifies RTC token generation with explicit user-account privileges.
Deno.test('BuildTokenWithUserAccountAndPrivilege_Test', () => {
    let token = RtcTokenBuilder.BuildTokenWithUserAccountAndPrivilege(appId, appCertificate, channelName, uidStr, expire, expire, expire, expire, expire)
    let accessToken = new AccessToken2('', '', 0, 0)
    accessToken.from_string(token)
    const service = accessToken.getServices(kRtcServiceType)[0]

    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
    assert(channelName === service.__channel_name)
    assert(uidStr === service.__uid)
    assert(expire === service.__privileges[ServiceRtc.kPrivilegeJoinChannel])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishAudioStream])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishVideoStream])
    assert(expire === service.__privileges[ServiceRtc.kPrivilegePublishDataStream])
})

// Verifies combined RTC and RTM token generation.
Deno.test('buildTokenWithRtm_Test', () => {
    const token = RtcTokenBuilder.buildTokenWithRtm(
        appId,
        appCertificate,
        channelName,
        uidStr,
        Role.PUBLISHER,
        expire,
        expire,
    )
    const accessToken = new AccessToken2('', '', 0, 0)

    assert(accessToken.from_string(token))
    assert(1 === accessToken.getServices(kRtcServiceType).length)
    assert(1 === accessToken.getServices(kRtmServiceType).length)
    assert(accessToken.verifySignature(appCertificate))
})

// Verifies combined RTC and RTM token generation with independent privileges.
Deno.test('buildTokenWithRtm2_Test', () => {
    const token = RtcTokenBuilder.buildTokenWithRtm2(
        appId,
        appCertificate,
        channelName,
        'rtc-account',
        Role.PUBLISHER,
        expire,
        1,
        2,
        3,
        4,
        'rtm-account',
        expire,
    )
    const accessToken = new AccessToken2('', '', 0, 0)

    assert(accessToken.from_string(token))
    const rtcService = accessToken.getServices(kRtcServiceType)[0]
    const rtmService = accessToken.getServices(kRtmServiceType)[0]
    assert(1 === rtcService.__privileges[ServiceRtc.kPrivilegeJoinChannel])
    assert(2 === rtcService.__privileges[ServiceRtc.kPrivilegePublishAudioStream])
    assert(3 === rtcService.__privileges[ServiceRtc.kPrivilegePublishVideoStream])
    assert(4 === rtcService.__privileges[ServiceRtc.kPrivilegePublishDataStream])
    assert('rtm-account' === rtmService.__user_id)
    assert(expire === rtmService.__privileges[ServiceRtm.kPrivilegeLogin])
    assert(accessToken.verifySignature(appCertificate))
})
