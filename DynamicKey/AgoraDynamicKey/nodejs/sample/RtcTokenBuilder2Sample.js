const RtcTokenBuilder = require('../src/RtcTokenBuilder2').RtcTokenBuilder
const RtcRole = require('../src/RtcTokenBuilder2').Role

const appID = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const channelName = '7d72365eb983485397e3e3f9d460bdda'
const uid = 2882341273
const account = "2882341273"
const role = RtcRole.PUBLISHER
const expirationInSeconds = 3600

const tokenExpirationInSecond = 3600
const privilegeExpirationInSecond = 3600
// Build token with uid
const tokenA = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, role, tokenExpirationInSecond, privilegeExpirationInSecond)
console.log("Token with int uid: " + tokenA)

// Build token with user account
const tokenB = RtcTokenBuilder.buildTokenWithUserAccount(appID, appCertificate, channelName, account, role, tokenExpirationInSecond, privilegeExpirationInSecond)
console.log("Token with user account: " + tokenB)

const tokenC = RtcTokenBuilder.buildTokenWithUidAndPrivilege(appID, appCertificate, channelName, uid,
    expirationInSeconds, expirationInSeconds, expirationInSeconds, expirationInSeconds, expirationInSeconds)
console.log("Token with int uid and privilege:" + tokenC)

const tokenD = RtcTokenBuilder.BuildTokenWithUserAccountAndPrivilege(appID, appCertificate, channelName, account,
    expirationInSeconds, expirationInSeconds, expirationInSeconds, expirationInSeconds, expirationInSeconds)
console.log("Token with user account and privilege:" + tokenD)
