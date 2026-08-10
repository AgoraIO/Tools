import { SttTokenBuilder } from '../src/SttTokenBuilder.js'
import { AccessToken2, kRtcServiceType, kRtmServiceType, kSttServiceType, ServiceRtc, ServiceRtm } from '../src/AccessToken2.js'
import { Role } from '../src/RtcTokenBuilder2.js'
import { assert, assertEquals } from 'https://deno.land/std/testing/asserts.ts'

const appId = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const channelName = 'stt-channel'
const rtcAccount = 'stt-rtc-user'
const rtmUserId = 'stt-rtm-user'
const rtcTokenExpire = 3600
const joinChannelPrivilegeExpire = 1800
const pubAudioPrivilegeExpire = 1700
const pubVideoPrivilegeExpire = 1600
const pubDataStreamPrivilegeExpire = 1500
const rtmTokenExpire = 1400

Deno.test('SttTokenBuilder publisher token', () => {
  const token = SttTokenBuilder.buildToken(
    appId, appCertificate, channelName, rtcAccount, Role.PUBLISHER, rtcTokenExpire,
    joinChannelPrivilegeExpire, pubAudioPrivilegeExpire, pubVideoPrivilegeExpire,
    pubDataStreamPrivilegeExpire, rtmUserId, rtmTokenExpire,
  )
  const parsed = new AccessToken2('', '', 0, 0)
  assert(parsed.from_string(token))
  const rtc = parsed.getServices(kRtcServiceType)[0]
  const rtm = parsed.getServices(kRtmServiceType)[0]
  const stt = parsed.getServices(kSttServiceType)[0]
  assertEquals(parsed.appId, appId)
  assertEquals(parsed.expire, rtcTokenExpire)
  assertEquals(rtc.__channel_name, channelName)
  assertEquals(rtc.__uid, rtcAccount)
  assertEquals(rtc.__privileges[ServiceRtc.kPrivilegeJoinChannel], joinChannelPrivilegeExpire)
  assertEquals(rtc.__privileges[ServiceRtc.kPrivilegePublishAudioStream], pubAudioPrivilegeExpire)
  assertEquals(rtc.__privileges[ServiceRtc.kPrivilegePublishVideoStream], pubVideoPrivilegeExpire)
  assertEquals(rtc.__privileges[ServiceRtc.kPrivilegePublishDataStream], pubDataStreamPrivilegeExpire)
  assertEquals(rtm.__user_id, rtmUserId)
  assertEquals(rtm.__privileges[ServiceRtm.kPrivilegeLogin], rtmTokenExpire)
  assertEquals(stt.__privileges, {})
})

Deno.test('SttTokenBuilder subscriber token', () => {
  const token = SttTokenBuilder.buildToken(
    appId, appCertificate, channelName, rtcAccount, Role.SUBSCRIBER, rtcTokenExpire,
    joinChannelPrivilegeExpire, pubAudioPrivilegeExpire, pubVideoPrivilegeExpire,
    pubDataStreamPrivilegeExpire, rtmUserId, rtmTokenExpire,
  )
  const parsed = new AccessToken2('', '', 0, 0)
  assert(parsed.from_string(token))
  const rtc = parsed.getServices(kRtcServiceType)[0]
  assertEquals(rtc.__privileges, { [ServiceRtc.kPrivilegeJoinChannel]: joinChannelPrivilegeExpire })
})
