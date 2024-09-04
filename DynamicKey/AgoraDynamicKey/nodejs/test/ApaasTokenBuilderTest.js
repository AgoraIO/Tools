/**
 * run this test with command:
 * nodeunit test/ApaasTokenBuilderTest.js
 * see https://github.com/caolan/nodeunit
 */
const ApaasTokenBuilder = require('../src/ApaasTokenBuilder').ApaasTokenBuilder
const { AccessToken2, kApaasServiceType } = require('../src/AccessToken2')
const appId = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const expire = 600
const roomUuid = '123'
const userUuid = '2882341273'
const role = 1

exports.BuildRoomUserToken_Test = function (test) {
    let accessToken = new AccessToken2('', '', 0, 0)
    let token = ApaasTokenBuilder.buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire)
    accessToken.from_string(token)
    test.equal(appId, accessToken.appId)
    test.equal(expire, accessToken.expire)
    test.equal(roomUuid, accessToken.services[kApaasServiceType].__room_uuid)
    test.equal(userUuid, accessToken.services[kApaasServiceType].__user_uuid)
    test.equal(role, accessToken.services[kApaasServiceType].__role)
    test.done()
}

exports.BuildUserToken_Test = function (test) {
    let accessToken = new AccessToken2('', '', 0, 0)
    let token = ApaasTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expire)
    accessToken.from_string(token)

    test.equal(appId, accessToken.appId)
    test.equal(expire, accessToken.expire)
    test.equal(userUuid, accessToken.services[kApaasServiceType].__user_uuid)
    test.done()
}

exports.BuildAppToken_Test = function (test) {
    let accessToken = new AccessToken2('', '', 0, 0)
    let token = ApaasTokenBuilder.buildAppToken(appId, appCertificate, expire)
    accessToken.from_string(token)
    test.equal(appId, accessToken.appId)
    test.equal(expire, accessToken.expire)
    test.done()
}
