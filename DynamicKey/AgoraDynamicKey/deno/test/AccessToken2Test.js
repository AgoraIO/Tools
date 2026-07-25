/**
 * Run this test with: deno test test/AccessToken2Test.js
 */
import {
    AccessToken2,
    kFCdnServiceType,
    kRtcServiceType,
    kRtm2ServiceType,
    kRtmServiceType,
    kStreamingServiceType,
    Rtm2Permissions,
    Service,
    ServiceChat,
    ServiceFCdn,
    ServiceRtc,
    ServiceRtm,
    ServiceRtm2,
    ServiceStreaming,
} from '../src/AccessToken2.js'
import { assert, assertEquals, assertFalse, assertStrictEquals } from 'https://deno.land/std/testing/asserts.ts'

const appID = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const channel = '7d72365eb983485397e3e3f9d460bdda'
const uid = 2882341273
const uidStr = '2882341273'
const ts = 1111111
const expire = 600
const salt = 1
const userID = 'test_user'

// Represents an unsupported service type for forward compatibility tests.
class UnknownService extends Service {
    // Creates a service whose type is not registered by AccessToken2.
    constructor(serviceType = 999) {
        super(serviceType)
    }
}

// Verifies deterministic RTC token generation with a numeric user ID.
Deno.test('AccessToken_Test', () => {
    const expected =
        '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)

    assertEquals(token.build(), expected)
})

// Verifies deterministic RTC token generation with an empty user ID.
Deno.test('AccessToken_Test2', () => {
    const expected =
        '007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo='
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtcService = new ServiceRtc(channel, 0)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)

    assertEquals(token.build(), expected)
})

// Verifies deterministic RTC token generation with a string user account.
Deno.test('AccessToken_Test3', () => {
    const expected =
        '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtcService = new ServiceRtc(channel, uidStr)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)

    assertEquals(token.build(), expected)
})

// Verifies deterministic token generation with distinct service types.
Deno.test('AccessToken_Test4', () => {
    const expected =
        '007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4'
    const token = createRtcRtmToken()

    assertEquals(token.build(), expected)
})

// Verifies deterministic Chat user token generation.
Deno.test('AccessToken_Test_buildChatUserToken', () => {
    const expected =
        '007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg='
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const chatService = new ServiceChat(uidStr)
    chatService.add_privilege(ServiceChat.kPrivilegeUser, expire)
    token.add_service(chatService)

    assertEquals(token.build(), expected)
})

// Verifies deterministic Chat application token generation.
Deno.test('AccessToken_Test_buildChatAppToken', () => {
    const expected = '007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr'
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const chatService = new ServiceChat()
    chatService.add_privilege(ServiceChat.kPrivilegeApp, expire)
    token.add_service(chatService)

    assertEquals(token.build(), expected)
})

// Preserves repeated service types and their insertion order after parsing.
Deno.test('AccessToken_Test_repeatedServiceTypes', () => {
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt

    const rtmService = new ServiceRtm(userID)
    rtmService.add_privilege(ServiceRtm.kPrivilegeLogin, expire + 50)
    token.add_service(rtmService)

    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)

    const streamService = new ServiceRtc('stream-channel', 'stream-user')
    streamService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire + 100)
    streamService.add_privilege(ServiceRtc.kPrivilegePublishDataStream, expire + 100)
    token.add_service(streamService)

    assertEquals(token.getServices(kRtcServiceType).length, 2)
    assertStrictEquals(token.services[0], rtmService)

    const parsed = new AccessToken2('', '', 0, 0)
    assert(parsed.from_string(token.build()))
    const rtcServices = parsed.getServices(kRtcServiceType)
    assertEquals(rtcServices.length, 2)
    assertEquals(rtcServices[0].__channel_name, channel)
    assertEquals(rtcServices[1].__channel_name, 'stream-channel')
    assertEquals(rtcServices[1].__privileges[ServiceRtc.kPrivilegePublishDataStream], expire + 100)
    assertEquals(parsed.getServices(kRtmServiceType).length, 1)
    assert(parsed.verifySignature(appCertificate))
    assertFalse(parsed.verifySignature('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'))
})

// Parses and verifies C++ Streaming, FCDN, and RTM2 services.
Deno.test('AccessToken_Test_extendedServicesFromCpp', () => {
    const encoded =
        '007eJxTYPj86Lzdz79M25wNn/lMfvu+TkfmdpiviKvChm8ZV3SWndytwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs7P5FgCGCiYGBkYGBgRkImYAsEJ8JTCowmKeYGxmbmaYmWVoYm1iYGluapxqnGqdZppiYGSSlpCRyMRhZWBgZmxgamRuzUaSbA6gXopuToSS1uCS+tDi1iJkB4jQmoGBuanFxYnqqbiKCmcTIAIEcDMUlRamJubqJLGD1jAxsDCD9uokAO/VDvQ=='
    const parsed = new AccessToken2('', '', 0, 0)

    assert(parsed.from_string(encoded))
    assert(parsed.verifySignature(appCertificate))

    const streaming = parsed.getServices(kStreamingServiceType)[0]
    assertEquals(streaming.__channel_name, channel)
    assertEquals(streaming.__account, uidStr)
    assertEquals(streaming.__privileges[ServiceStreaming.kPrivilegePublishMixStream], expire)
    assertEquals(streaming.__privileges[ServiceStreaming.kPrivilegePublishRawStream], expire)

    const fcdn = parsed.getServices(kFCdnServiceType)[0]
    assertEquals(fcdn.__channel_name, channel)
    assertEquals(fcdn.__account, uidStr)
    assertEquals(fcdn.__privileges[ServiceFCdn.kPrivilegePublish], expire)
    assertEquals(fcdn.__privileges[ServiceFCdn.kPrivilegePlay], expire)

    const rtm2 = parsed.getServices(kRtm2ServiceType)[0]
    assertEquals(rtm2.__user_id, userID)
    assertEquals(rtm2.__permissions.details, {
        0: { 0: ['message-a', 'message-b'] },
        1: { 1: ['stream-a'] },
        4: { 0: ['user-a'] },
    })
    assertEquals(rtm2.__privileges[ServiceRtm2.kPrivilegeLogin], expire)
})

// Verifies deterministic Streaming and FCDN generation and UID conversion against C++.
Deno.test('AccessToken_Test_extendedServiceNumericUidConversion', () => {
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const streamingUid = new ServiceStreaming(channel, uid)
    streamingUid.add_privilege(ServiceStreaming.kPrivilegePublishMixStream, expire)
    token.add_service(streamingUid)
    const streamingWildcard = new ServiceStreaming(channel, 0)
    streamingWildcard.add_privilege(ServiceStreaming.kPrivilegePublishRawStream, expire)
    token.add_service(streamingWildcard)
    const streamingAccount = new ServiceStreaming(channel, 'stream-account')
    streamingAccount.add_privilege(ServiceStreaming.kPrivilegePublishMixStream, expire)
    streamingAccount.add_privilege(ServiceStreaming.kPrivilegePublishRawStream, expire)
    token.add_service(streamingAccount)
    const fcdnUid = new ServiceFCdn(channel, uid)
    fcdnUid.add_privilege(ServiceFCdn.kPrivilegePublish, expire)
    token.add_service(fcdnUid)
    const fcdnWildcard = new ServiceFCdn(channel, 0)
    fcdnWildcard.add_privilege(ServiceFCdn.kPrivilegePlay, expire)
    token.add_service(fcdnWildcard)
    const fcdnAccount = new ServiceFCdn(channel, 'fcdn-account')
    fcdnAccount.add_privilege(ServiceFCdn.kPrivilegePublish, expire)
    fcdnAccount.add_privilege(ServiceFCdn.kPrivilegePlay, expire)
    token.add_service(fcdnAccount)

    const encoded = token.build()
    assertEquals(
        encoded,
        '007eJxTYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwA2lGMF+BwTzF3MjYzDQ1ydLC2MTC1NjSPNU41TjNMsXEzCApJSWRi8HIwsLI2MTQyNwYpI+JSH0MQFuYoLYQq4ePobikKDUxVzcxOTm/NK+EjUx3spHkTjaS3cnDkJackgdzJQBJb19X',
    )
    const parsed = new AccessToken2('', '', 0, 0)
    assert(parsed.from_string(encoded))
    assertEquals(
        parsed.getServices(kStreamingServiceType).map((service) => service.__account),
        [uidStr, '', 'stream-account'],
    )
    assertEquals(
        parsed.getServices(kFCdnServiceType).map((service) => service.__account),
        [uidStr, '', 'fcdn-account'],
    )
})

// Generates and parses an RTM2 token whose uncompressed payload exceeds the initial buffer capacity.
Deno.test('AccessToken_Test_largeRtm2PermissionPayload', () => {
    const resources = Array.from({ length: 160 }, (_, index) => `resource-${index.toString().padStart(4, '0')}`)
    const permissions = new Rtm2Permissions()
    permissions.add(Rtm2Permissions.kUsers, Rtm2Permissions.kRead, resources)

    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtm2Service = new ServiceRtm2(userID, permissions)
    rtm2Service.add_privilege(ServiceRtm2.kPrivilegeLogin, expire)
    token.add_service(rtm2Service)

    const parsed = new AccessToken2('', '', 0, 0)
    assert(parsed.from_string(token.build()))
    assert(parsed.verifySignature(appCertificate))
    assertEquals(
        parsed.getServices(kRtm2ServiceType)[0].__permissions.details[Rtm2Permissions.kUsers][Rtm2Permissions.kRead],
        resources,
    )
})

// Keeps known services parsed before an unknown service type.
Deno.test('AccessToken_Test_unknownServiceAfterKnownService', () => {
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)
    const unknownService = new UnknownService()
    unknownService.add_privilege(1, expire)
    token.add_service(unknownService)

    const parsed = new AccessToken2('', '', 0, 0)
    assert(parsed.from_string(token.build()))
    assertEquals(parsed.getServices(kRtcServiceType).length, 1)
    assertEquals(parsed.getServices(999).length, 0)
    assert(parsed.verifySignature(appCertificate))
})

// Stops before known services that follow an unknown service payload.
Deno.test('AccessToken_Test_unknownServiceBeforeKnownService', () => {
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)
    const unknownService = new UnknownService(0)
    unknownService.add_privilege(1, expire)
    token.add_service(unknownService)

    const parsed = new AccessToken2('', '', 0, 0)
    assert(parsed.from_string(token.build()))
    assertEquals(parsed.getServices(kRtcServiceType).length, 0)
    assert(parsed.verifySignature(appCertificate))
})

// Parses an old token and replaces services from an earlier parse.
Deno.test('AccessToken_Test_parseOldTokenAndClearServices', () => {
    const parsed = new AccessToken2('', '', 0, 0)
    assert(parsed.from_string(createRtcRtmToken().build()))
    assertEquals(parsed.getServices(kRtmServiceType).length, 1)

    const oldToken =
        '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
    assert(parsed.from_string(oldToken))
    assertEquals(parsed.services.length, 1)
    assertEquals(parsed.getServices(kRtcServiceType).length, 1)
    assertEquals(parsed.getServices(kRtmServiceType).length, 0)
    assert(parsed.verifySignature(appCertificate))
})

// Rejects signature verification before parsing or with invalid certificates.
Deno.test('AccessToken_Test_verifySignaturePreconditions', () => {
    const parsed = new AccessToken2('', '', 0, 0)
    assertFalse(parsed.verifySignature(appCertificate))
    assertFalse(parsed.from_string('006invalid'))
    assertFalse(parsed.from_string('007invalid'))

    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)

    assert(parsed.from_string(token.build()))
    assertFalse(parsed.verifySignature(null))
    assertFalse(parsed.verifySignature('invalid'))
    assertFalse(parsed.verifySignature('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'))
    assert(parsed.verifySignature(appCertificate))

    assertFalse(parsed.from_string('006invalid'))
    assertFalse(parsed.verifySignature(appCertificate))
    assertEquals(parsed.services.length, 0)
})

// Sorts distinct service types before packing without changing insertion order.
Deno.test('AccessToken_Test_stableServiceTypeOrdering', () => {
    const expected =
        '007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4'
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtmService = new ServiceRtm(userID)
    rtmService.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
    token.add_service(rtmService)
    const rtcService = createRtcService()
    token.add_service(rtcService)

    assertEquals(token.build(), expected)
    assertStrictEquals(token.services[0], rtmService)
})

// Rejects invalid build fields, non-string tokens, and malformed Token007 payloads.
Deno.test('AccessToken_Test_invalidBuildAndParseInputs', () => {
    const empty = new AccessToken2(appID, appCertificate, ts, expire)
    assertEquals(empty.build(), '')

    const invalid = new AccessToken2('invalid', appCertificate, ts, expire)
    invalid.add_service(createRtcService())
    assertEquals(invalid.build(), '')

    const parsed = new AccessToken2('', '', 0, 0)
    assertFalse(parsed.from_string(null))
    assertFalse(parsed.from_string('00'))
    assertFalse(parsed.from_string('007invalid'))
})

// Rejects verification when the parsed signature length is altered.
Deno.test('AccessToken_Test_signatureLengthMismatch', () => {
    const parsed = new AccessToken2('', '', 0, 0)
    assert(parsed.from_string(createRtcRtmToken().build()))
    parsed.__signature = new Uint8Array(1)

    assertFalse(parsed.verifySignature(appCertificate))
})

// Creates a fully privileged RTC service for deterministic tests.
function createRtcService() {
    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    rtcService.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, expire)
    rtcService.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, expire)
    rtcService.add_privilege(ServiceRtc.kPrivilegePublishDataStream, expire)
    return rtcService
}

// Creates a deterministic token containing RTC and RTM services.
function createRtcRtmToken() {
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    token.add_service(createRtcService())
    const rtmService = new ServiceRtm(userID)
    rtmService.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
    token.add_service(rtmService)
    return token
}
