const { SttTokenBuilder, RtcRole } = require('..')

const appId = process.env.AGORA_APP_ID
const appCertificate = process.env.AGORA_APP_CERTIFICATE
const channelName = '7d72365eb983485397e3e3f9d460bdda'
const rtcAccount = '2882341273'
const rtcRole = RtcRole.PUBLISHER
const rtcTokenExpire = 3600
const joinChannelPrivilegeExpire = 3600
const pubAudioPrivilegeExpire = 3600
const pubVideoPrivilegeExpire = 3600
const pubDataStreamPrivilegeExpire = 3600
const rtmUserId = '2882341273'
const rtmTokenExpire = 3600

console.log('App Id:', appId)
if (!appId || !appCertificate) {
    console.log('Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE')
    process.exit(0)
}

const token = SttTokenBuilder.buildToken(
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
    rtmTokenExpire
)
console.log('STT token:', token)
