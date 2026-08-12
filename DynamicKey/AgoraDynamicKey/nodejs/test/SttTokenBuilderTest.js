/**
 * run this test with command:
 * nodeunit test/SttTokenBuilderTest.js
 */
const { SttTokenBuilder } = require('../src/SttTokenBuilder')
const { AccessToken2, kRtcServiceType, kRtmServiceType, kSttServiceType, ServiceRtc, ServiceRtm } = require('../src/AccessToken2')
const { Role } = require('../src/RtcTokenBuilder2')

const appId = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const channelName = '7d72365eb983485397e3e3f9d460bdda'
const rtcAccount = '2882341273'
const rtmUserId = '2882341273'
const rtcTokenExpire = 600
const joinChannelPrivilegeExpire = 600
const pubAudioPrivilegeExpire = 600
const pubVideoPrivilegeExpire = 600
const pubDataStreamPrivilegeExpire = 600
const rtmTokenExpire = 600

exports.buildToken_PUBLISHER_Test = function (test) {
    const token = SttTokenBuilder.buildToken(
        appId, appCertificate, channelName, rtcAccount, Role.PUBLISHER, rtcTokenExpire,
        joinChannelPrivilegeExpire, pubAudioPrivilegeExpire, pubVideoPrivilegeExpire,
        pubDataStreamPrivilegeExpire, rtmUserId, rtmTokenExpire)
    const parsed = new AccessToken2('', '', 0, 0)
    parsed.from_string(token)

    const rtc = parsed.getServices(kRtcServiceType)[0]
    const rtm = parsed.getServices(kRtmServiceType)[0]
    const stt = parsed.getServices(kSttServiceType)[0]

    test.equal(appId, parsed.appId)
    test.equal(rtcTokenExpire, parsed.expire)
    test.equal(channelName, rtc.__channel_name)
    test.equal(rtcAccount, rtc.__uid)
    test.equal(joinChannelPrivilegeExpire, rtc.__privileges[ServiceRtc.kPrivilegeJoinChannel])
    test.equal(pubAudioPrivilegeExpire, rtc.__privileges[ServiceRtc.kPrivilegePublishAudioStream])
    test.equal(pubVideoPrivilegeExpire, rtc.__privileges[ServiceRtc.kPrivilegePublishVideoStream])
    test.equal(pubDataStreamPrivilegeExpire, rtc.__privileges[ServiceRtc.kPrivilegePublishDataStream])
    test.equal(rtmUserId, rtm.__user_id)
    test.equal(rtmTokenExpire, rtm.__privileges[ServiceRtm.kPrivilegeLogin])
    test.deepEqual({}, stt.__privileges)
    test.done()
}

exports.buildToken_SUBSCRIBER_Test = function (test) {
    const token = SttTokenBuilder.buildToken(
        appId, appCertificate, channelName, rtcAccount, Role.SUBSCRIBER, rtcTokenExpire,
        joinChannelPrivilegeExpire, pubAudioPrivilegeExpire, pubVideoPrivilegeExpire,
        pubDataStreamPrivilegeExpire, rtmUserId, rtmTokenExpire)
    const parsed = new AccessToken2('', '', 0, 0)
    parsed.from_string(token)

    const rtc = parsed.getServices(kRtcServiceType)[0]
    test.deepEqual({ [ServiceRtc.kPrivilegeJoinChannel]: joinChannelPrivilegeExpire }, rtc.__privileges)
    test.done()
}
