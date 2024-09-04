const ApaasTokenBuilder = require('../src/ApaasTokenBuilder').ApaasTokenBuilder

// Need to set environment variable AGORA_APP_ID
const appId = process.env.AGORA_APP_ID
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = process.env.AGORA_APP_CERTIFICATE

const expire = 600
const roomUuid = '123'
const userUuid = '2882341273'
const role = 1

console.log('App Id:', appId)
console.log('App Certificate:', appCertificate)
if (appId == undefined || appId == '' || appCertificate == undefined || appCertificate == '') {
    console.log('Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE')
    process.exit(1)
}

const tokenRoomUserToken = ApaasTokenBuilder.buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire)
console.log('Apaas room user token:', tokenRoomUserToken)

const tokenUserToken = ApaasTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expire)
console.log('Apaas user token:', tokenUserToken)

const tokenAppToken = ApaasTokenBuilder.buildAppToken(appId, appCertificate, expire)
console.log('Apaas app token:', tokenAppToken)
