import { ConvoAITokenBuilder } from '../src/ConvoAITokenBuilder.js'
import { Role } from '../src/RtcTokenBuilder2.js'

const appId = Deno.env.get('AGORA_APP_ID')
const appCertificate = Deno.env.get('AGORA_APP_CERTIFICATE')
const channelName = 'convoai-channel'
const rtcAccount = 'convoai-rtc-user'
const rtcRole = Role.PUBLISHER
const rtcTokenExpire = 3600
const joinChannelPrivilegeExpire = 3600
const pubAudioPrivilegeExpire = 3600
const pubVideoPrivilegeExpire = 3600
const pubDataStreamPrivilegeExpire = 3600
const rtmUserId = 'convoai-rtm-user'
const rtmTokenExpire = 3600

console.log('App Id:', appId)
if (!appId || !appCertificate) {
  console.log('Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE')
  Deno.exit(0)
}

const token = ConvoAITokenBuilder.buildToken(
  appId,
  appCertificate,
  channelName,
  rtcAccount,
  rtcRole,
  rtcTokenExpire,
  joinChannelPrivilegeExpire,
  pubAudioPrivilegeExpire,
  pubVideoPrivilegeExpire,
  pubDataStreamPrivilegeExpire,
  rtmUserId,
  rtmTokenExpire,
)
console.log('ConvoAI token:', token)
