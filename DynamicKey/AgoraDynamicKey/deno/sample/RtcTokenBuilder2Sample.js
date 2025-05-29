import { Role as RtcRole, RtcTokenBuilder } from '../src/RtcTokenBuilder2.js'

// Need to set environment variable AGORA_APP_ID
const appId = Deno.env.get('AGORA_APP_ID')
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = Deno.env.get('AGORA_APP_CERTIFICATE')

const channelName = '7d72365eb983485397e3e3f9d460bdda'
const uid = 2882341273
const account = '2882341273'
const role = RtcRole.PUBLISHER
const tokenExpirationInSecond = 3600
const privilegeExpirationInSecond = 3600
const joinChannelPrivilegeExpireInSeconds = 3600
const pubAudioPrivilegeExpireInSeconds = 3600
const pubVideoPrivilegeExpireInSeconds = 3600
const pubDataStreamPrivilegeExpireInSeconds = 3600

console.log('App Id:', appId)
console.log('App Certificate:', appCertificate)
if (appId == undefined || appId == '' || appCertificate == undefined || appCertificate == '') {
    console.log('Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE')
    Deno.exit(1)
}

// Build token with uid
const tokenWithUid = RtcTokenBuilder.buildTokenWithUid(appId, appCertificate, channelName, uid, role, tokenExpirationInSecond, privilegeExpirationInSecond)
console.log('Token with int uid:', tokenWithUid)

// Build token with user account
const tokenWithUserAccount = RtcTokenBuilder.buildTokenWithUserAccount(
    appId,
    appCertificate,
    channelName,
    account,
    role,
    tokenExpirationInSecond,
    privilegeExpirationInSecond,
)
console.log('Token with user account:', tokenWithUserAccount)

const tokenWithUidAndPrivilege = RtcTokenBuilder.buildTokenWithUidAndPrivilege(
    appId,
    appCertificate,
    channelName,
    uid,
    tokenExpirationInSecond,
    joinChannelPrivilegeExpireInSeconds,
    pubAudioPrivilegeExpireInSeconds,
    pubVideoPrivilegeExpireInSeconds,
    pubDataStreamPrivilegeExpireInSeconds,
)
console.log('Token with int uid and privilege:', tokenWithUidAndPrivilege)

const tokenWithUserAccountAndPrivilege = RtcTokenBuilder.BuildTokenWithUserAccountAndPrivilege(
    appId,
    appCertificate,
    channelName,
    account,
    tokenExpirationInSecond,
    joinChannelPrivilegeExpireInSeconds,
    pubAudioPrivilegeExpireInSeconds,
    pubVideoPrivilegeExpireInSeconds,
    pubDataStreamPrivilegeExpireInSeconds,
)
console.log('Token with user account and privilege:', tokenWithUserAccountAndPrivilege)

const tokenWithRtm = RtcTokenBuilder.buildTokenWithRtm(
    appId,
    appCertificate,
    channelName,
    account,
    role,
    tokenExpirationInSecond,
    privilegeExpirationInSecond,
)
console.log('Token with RTM:', tokenWithRtm)

const tokenWithRtm2 = RtcTokenBuilder.buildTokenWithRtm2(
    appId,
    appCertificate,
    channelName,
    account,
    role,
    tokenExpirationInSecond,
    joinChannelPrivilegeExpireInSeconds,
    pubAudioPrivilegeExpireInSeconds,
    pubVideoPrivilegeExpireInSeconds,
    pubDataStreamPrivilegeExpireInSeconds,
    account,
    tokenExpirationInSecond,
)
console.log('Token with RTM:', tokenWithRtm2)
