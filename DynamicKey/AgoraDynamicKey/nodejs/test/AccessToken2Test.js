/**
 * run this test with command:
 * nodeunit AccessTokenTest.js
 * see https://github.com/caolan/nodeunit
 */
const {
    AccessToken2,
    Rtm2Permissions,
    Service,
    ServiceRtc,
    ServiceRtm,
    ServiceStreaming,
    ServiceFCdn,
    ServiceRtm2,
    ServiceChat,
    kRtcServiceType,
    kRtmServiceType,
    kStreamingServiceType,
    kFCdnServiceType,
    kRtm2ServiceType,
    kChatServiceType
} = require('../src/AccessToken2')

var appID = '970CA35de60c44645bbae8a215061b33'
var appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
var channel = '7d72365eb983485397e3e3f9d460bdda'
var uid = 2882341273
var uidStr = '2882341273'
var ts = 1111111
var expire = 600
var salt = 1
var user_id = 'test_user'

// Represents an unsupported service type for forward compatibility tests.
class UnknownService extends Service {
    // Creates a service whose type is not registered by AccessToken2.
    constructor(serviceType = 999) {
        super(serviceType)
    }
}

// Verifies deterministic RTC token generation with a numeric user ID.
exports.AccessToken_Test = function (test) {
    var expected =
        '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let rtc_service = new ServiceRtc(channel, uid)
    rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtc_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

// Verifies deterministic RTC token generation with an empty user ID.
exports.AccessToken_Test2 = function (test) {
    var expected =
        '007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo='

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let rtc_service = new ServiceRtc(channel, 0)
    rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtc_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

// Verifies deterministic RTC token generation with a string user account.
exports.AccessToken_Test3 = function (test) {
    var expected =
        '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let rtc_service = new ServiceRtc(channel, `${uid}`)
    rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtc_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

// Verifies deterministic token generation with distinct service types.
exports.AccessToken_Test4 = function (test) {
    var expected =
        '007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmBgYGVgYGMF8JjDJDCZZwKQCg3mKuZGxmWlqkqWFsYmFqbGleapxqnGaZYqJmUFSSkoiF4ORhYWRsYmhkbkxyCyISZwMJanFJfGlxalFACKnKng='

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let rtc_service = new ServiceRtc(channel, uid)
    rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    rtc_service.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, expire)
    rtc_service.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, expire)
    rtc_service.add_privilege(ServiceRtc.kPrivilegePublishDataStream, expire)
    token.add_service(rtc_service)

    let rtm_service = new ServiceRtm(user_id)
    rtm_service.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
    token.add_service(rtm_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

// Verifies deterministic Chat user token generation.
exports.AccessToken_Test_buildChatUserToken = function (test) {
    var expected =
        '007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrAyMDIxgPheDkYWFkbGJoZG5MQAfpR64'

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let chat_service = new ServiceChat(uidStr)
    chat_service.add_privilege(ServiceChat.kPrivilegeUser, expire)
    token.add_service(chat_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

// Verifies deterministic Chat application token generation.
exports.AccessToken_Test_buildChatAppToken = function (test) {
    var expected =
        '007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZGRgZmMB8BgYArfIYaw=='

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let chat_service = new ServiceChat()
    chat_service.add_privilege(ServiceChat.kPrivilegeApp, expire)
    token.add_service(chat_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

// Preserves repeated service types and their insertion order after parsing.
exports.AccessToken_Test_repeatedServiceTypes = function (test) {
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt

    const rtmService = new ServiceRtm(user_id)
    rtmService.add_privilege(ServiceRtm.kPrivilegeLogin, expire + 50)
    token.add_service(rtmService)

    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)

    const streamRtcService = new ServiceRtc('stream-channel', 'stream-user')
    streamRtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire + 100)
    streamRtcService.add_privilege(ServiceRtc.kPrivilegePublishDataStream, expire + 100)
    token.add_service(streamRtcService)

    const encoded = token.build()
    test.equal(3, token.services.length)
    test.strictEqual(rtmService, token.services[0])
    test.equal(2, token.getServices(kRtcServiceType).length)

    const parsed = new AccessToken2('', '', 0, 0)
    test.equal(true, parsed.from_string(encoded))
    const rtcServices = parsed.getServices(kRtcServiceType)
    test.equal(2, rtcServices.length)
    test.equal(channel, rtcServices[0].__channel_name.toString())
    test.equal('stream-channel', rtcServices[1].__channel_name.toString())
    test.equal(expire + 100, rtcServices[1].__privileges[ServiceRtc.kPrivilegePublishDataStream])
    test.equal(1, parsed.getServices(kRtmServiceType).length)
    test.equal(0, parsed.getServices(kChatServiceType).length)
    test.equal(true, parsed.verifySignature(appCertificate))
    test.equal(false, parsed.verifySignature('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'))
    test.done()
}

// Parses and verifies C++ Streaming, FCDN, and RTM2 services.
exports.AccessToken_Test_extendedServicesFromCpp = function (test) {
    const encoded = '007eJxTYPj86Lzdz79M25wNn/lMfvu+TkfmdpiviKvChm8ZV3SWndytwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs7P5FgCGCiYGBkYGBgRkImYAsEJ8JTCowmKeYGxmbmaYmWVoYm1iYGluapxqnGqdZppiYGSSlpCRyMRhZWBgZmxgamRuzUaSbA6gXopuToSS1uCS+tDi1iJkB4jQmoGBuanFxYnqqbiKCmcTIAIEcDMUlRamJubqJLGD1jAxsDCD9uokAO/VDvQ=='
    const parsed = new AccessToken2('', '', 0, 0)

    test.equal(true, parsed.from_string(encoded))
    test.equal(true, parsed.verifySignature(appCertificate))

    const streaming = parsed.getServices(kStreamingServiceType)[0]
    test.equal(channel, streaming.__channel_name.toString())
    test.equal(uidStr, streaming.__account.toString())
    test.equal(expire, streaming.__privileges[ServiceStreaming.kPrivilegePublishMixStream])
    test.equal(expire, streaming.__privileges[ServiceStreaming.kPrivilegePublishRawStream])

    const fcdn = parsed.getServices(kFCdnServiceType)[0]
    test.equal(channel, fcdn.__channel_name.toString())
    test.equal(uidStr, fcdn.__account.toString())
    test.equal(expire, fcdn.__privileges[ServiceFCdn.kPrivilegePublish])
    test.equal(expire, fcdn.__privileges[ServiceFCdn.kPrivilegePlay])

    const rtm2 = parsed.getServices(kRtm2ServiceType)[0]
    test.equal(user_id, rtm2.__user_id.toString())
    test.deepEqual({
        0: { 0: ['message-a', 'message-b'] },
        1: { 1: ['stream-a'] },
        4: { 0: ['user-a'] }
    }, rtm2.__permissions.details)
    test.equal(expire, rtm2.__privileges[ServiceRtm2.kPrivilegeLogin])
    test.done()
}

// Verifies deterministic Streaming and FCDN generation and UID conversion against C++.
exports.AccessToken_Test_extendedServiceNumericUidConversion = function (test) {
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
    test.equal(
        encoded,
        '007eJxTYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwMzAyMIL5CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxiB9TETqY2BgZmCC2kKsHj6G4pKi1MRc3cTk5PzSvBI2Mt3JRpI72Uh2Jw9DWnJKHsyVAElvX1c='
    )
    const parsed = new AccessToken2('', '', 0, 0)
    test.equal(true, parsed.from_string(encoded))
    test.deepEqual(
        parsed.getServices(kStreamingServiceType).map(service => service.__account.toString()),
        [uidStr, '', 'stream-account']
    )
    test.deepEqual(
        parsed.getServices(kFCdnServiceType).map(service => service.__account.toString()),
        [uidStr, '', 'fcdn-account']
    )
    test.done()
}

// Generates and parses an RTM2 token whose uncompressed payload exceeds the initial buffer capacity.
exports.AccessToken_Test_largeRtm2PermissionPayload = function (test) {
    const resources = Array.from({ length: 160 }, (_, index) => `resource-${index.toString().padStart(4, '0')}`)
    const permissions = new Rtm2Permissions()
    permissions.add(Rtm2Permissions.kUsers, Rtm2Permissions.kRead, resources)

    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtm2Service = new ServiceRtm2(user_id, permissions)
    rtm2Service.add_privilege(ServiceRtm2.kPrivilegeLogin, expire)
    token.add_service(rtm2Service)

    const parsed = new AccessToken2('', '', 0, 0)
    test.equal(true, parsed.from_string(token.build()))
    test.equal(true, parsed.verifySignature(appCertificate))
    test.deepEqual(resources, parsed.getServices(kRtm2ServiceType)[0].__permissions.details[Rtm2Permissions.kUsers][Rtm2Permissions.kRead])
    test.done()
}

// Keeps known services parsed before an unknown service type.
exports.AccessToken_Test_unknownServiceAfterKnownService = function (test) {
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt

    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)

    const unknownService = new UnknownService()
    unknownService.add_privilege(1, expire)
    token.add_service(unknownService)

    const parsed = new AccessToken2('', '', 0, 0)
    test.equal(true, parsed.from_string(token.build()))
    test.equal(1, parsed.getServices(kRtcServiceType).length)
    test.equal(0, parsed.getServices(999).length)
    test.equal(true, parsed.verifySignature(appCertificate))
    test.done()
}

// Stops before known services that follow an unknown service payload.
exports.AccessToken_Test_unknownServiceBeforeKnownService = function (test) {
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt

    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)

    const unknownService = new UnknownService(0)
    unknownService.add_privilege(1, expire)
    token.add_service(unknownService)

    const parsed = new AccessToken2('', '', 0, 0)
    test.equal(true, parsed.from_string(token.build()))
    test.equal(0, parsed.getServices(kRtcServiceType).length)
    test.equal(true, parsed.verifySignature(appCertificate))
    test.done()
}

// Parses an old token and replaces services from an earlier parse.
exports.AccessToken_Test_parseOldTokenAndClearServices = function (test) {
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtmService = new ServiceRtm(user_id)
    rtmService.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
    token.add_service(rtmService)

    const parsed = new AccessToken2('', '', 0, 0)
    test.equal(true, parsed.from_string(token.build()))
    test.equal(1, parsed.getServices(kRtmServiceType).length)

    const oldToken =
        '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'
    test.equal(true, parsed.from_string(oldToken))
    test.equal(1, parsed.services.length)
    test.equal(1, parsed.getServices(kRtcServiceType).length)
    test.equal(0, parsed.getServices(kRtmServiceType).length)
    test.equal(true, parsed.verifySignature(appCertificate))
    test.done()
}

// Rejects signature verification before parsing or with invalid certificates.
exports.AccessToken_Test_verifySignaturePreconditions = function (test) {
    const parsed = new AccessToken2('', '', 0, 0)
    test.equal(false, parsed.verifySignature(appCertificate))

    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtcService)

    test.equal(true, parsed.from_string(token.build()))
    test.equal(false, parsed.verifySignature(null))
    test.equal(false, parsed.verifySignature('invalid'))
    test.equal(false, parsed.verifySignature('zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'))
    test.equal(true, parsed.verifySignature(appCertificate))

    test.equal(false, parsed.from_string('006invalid'))
    test.equal(false, parsed.verifySignature(appCertificate))
    test.equal(0, parsed.services.length)
    test.done()
}

// Sorts distinct service types before packing without changing insertion order.
exports.AccessToken_Test_stableServiceTypeOrdering = function (test) {
    const token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt

    const rtmService = new ServiceRtm(user_id)
    rtmService.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
    token.add_service(rtmService)

    const rtcService = new ServiceRtc(channel, uid)
    rtcService.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    rtcService.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, expire)
    rtcService.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, expire)
    rtcService.add_privilege(ServiceRtc.kPrivilegePublishDataStream, expire)
    token.add_service(rtcService)

    const expected =
        '007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmBgYGVgYGMF8JjDJDCZZwKQCg3mKuZGxmWlqkqWFsYmFqbGleapxqnGaZYqJmUFSSkoiF4ORhYWRsYmhkbkxyCyISZwMJanFJfGlxalFACKnKng='
    test.equal(expected, token.build())
    test.strictEqual(rtmService, token.services[0])
    test.done()
}
