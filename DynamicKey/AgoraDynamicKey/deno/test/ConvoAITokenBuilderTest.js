import { ConvoAITokenBuilder } from '../src/ConvoAITokenBuilder.js'
import { AccessToken2, kConvoAIServiceType, kRtcServiceType, kRtmServiceType, ServiceRtc, ServiceRtm } from '../src/AccessToken2.js'
import { Role } from '../src/RtcTokenBuilder2.js'
import { assert, assertEquals } from 'https://deno.land/std/testing/asserts.ts'

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

Deno.test('ConvoAITokenBuilder publisher token', () => {
  const token = ConvoAITokenBuilder.buildToken(
    appId, appCertificate, channelName, rtcAccount, Role.PUBLISHER, rtcTokenExpire,
    joinChannelPrivilegeExpire, pubAudioPrivilegeExpire, pubVideoPrivilegeExpire,
    pubDataStreamPrivilegeExpire, rtmUserId, rtmTokenExpire,
  )
  const parsed = new AccessToken2('', '', 0, 0)
  assert(parsed.from_string(token))
  const rtc = parsed.getServices(kRtcServiceType)[0]
  const rtm = parsed.getServices(kRtmServiceType)[0]
  const convoai = parsed.getServices(kConvoAIServiceType)[0]
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
  assertEquals(convoai.__privileges, {})
})

Deno.test('ConvoAITokenBuilder subscriber token', () => {
  const token = ConvoAITokenBuilder.buildToken(
    appId, appCertificate, channelName, rtcAccount, Role.SUBSCRIBER, rtcTokenExpire,
    joinChannelPrivilegeExpire, pubAudioPrivilegeExpire, pubVideoPrivilegeExpire,
    pubDataStreamPrivilegeExpire, rtmUserId, rtmTokenExpire,
  )
  const parsed = new AccessToken2('', '', 0, 0)
  assert(parsed.from_string(token))
  const rtc = parsed.getServices(kRtcServiceType)[0]
  assertEquals(rtc.__privileges, { [ServiceRtc.kPrivilegeJoinChannel]: joinChannelPrivilegeExpire })
})
