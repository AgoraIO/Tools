/**
 * Run this test with: deno test test/AccessToken2Test.js
 */
import { AccessToken2, kRtcServiceType, kRtmServiceType, Service, ServiceChat, ServiceRtc, ServiceRtm } from '../src/AccessToken2.js'
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
