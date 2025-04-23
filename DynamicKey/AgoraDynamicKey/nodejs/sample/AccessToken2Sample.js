const { AccessToken2, ServiceRtc } = require('../src/AccessToken2')
const RtcRole = require('../src/RtcTokenBuilder2').Role

// Need to set environment variable AGORA_APP_ID
const appId = process.env.AGORA_APP_ID
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = process.env.AGORA_APP_CERTIFICATE

const channelName = '7d72365eb983485397e3e3f9d460bdda'
const uid = 2882341273
// const account = '2882341273'
const role = RtcRole.PUBLISHER
const tokenExpirationInSecond = 3600
const joinChannelPrivilegeExpireInSeconds = 3600
const pubAudioPrivilegeExpireInSeconds = 3600
const pubVideoPrivilegeExpireInSeconds = 3600
const pubDataStreamPrivilegeExpireInSeconds = 3600

console.log('App Id:', appId)
console.log('App Certificate:', appCertificate)
if (appId == undefined || appId == '' || appCertificate == undefined || appCertificate == '') {
    console.log('Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE')
    process.exit(1)
}

let token = new AccessToken2(appId, appCertificate, 0, tokenExpirationInSecond)
let serviceRtc = new ServiceRtc(channelName, uid)
serviceRtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, joinChannelPrivilegeExpireInSeconds)
if (role == RtcRole.PUBLISHER) {
    serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, pubAudioPrivilegeExpireInSeconds)
    serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, pubVideoPrivilegeExpireInSeconds)
    serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, pubDataStreamPrivilegeExpireInSeconds)
}
token.add_service(serviceRtc)

console.log('Token: ', token.build())
