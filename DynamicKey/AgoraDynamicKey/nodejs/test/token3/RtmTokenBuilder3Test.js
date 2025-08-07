/**
 * run this test with command:
 * nodeunit test/token3/RtmTokenBuilder3Test.js
 * see https://github.com/caolan/nodeunit
 */
const RtmTokenBuilder = require('../../src/token3/RtmTokenBuilder3').RtmTokenBuilder
const RtmPermission = require('../../src/token3/RtmTokenBuilder3').RtmPermission
const { AccessToken3, ServiceRtm, kRtmServiceType } = require('../../src/token3/AccessToken3')

const appId = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const userId = 'test_user'
const expire = 600

exports.buildToken = function (test) {
    const permissions = {
        [RtmPermission.resourceKeys.kMessageChannels]: {
            [RtmPermission.permissionKeys.kRead]: ['channel_1*', 'channel_2'],
            [RtmPermission.permissionKeys.kWrite]: ['channel_3']
        },
        [RtmPermission.resourceKeys.kStreamChannels]: {
            [RtmPermission.permissionKeys.kRead]: ['*'],
            [RtmPermission.permissionKeys.kWrite]: ['channel_4']
        }
    }
    let token = RtmTokenBuilder.buildToken(appId, appCertificate, userId, expire, permissions)
    let accessToken = new AccessToken3('', '', 0, 0)
    accessToken.from_string(token)

    test.equal(appId, accessToken.appId)
    test.equal(expire, accessToken.expire)
    test.equal(userId, accessToken.services[kRtmServiceType].__user_id)
    test.equal(expire, accessToken.services[kRtmServiceType].__privileges[ServiceRtm.kPrivilegeLogin])
    const objToMap = RtmTokenBuilder._objToMap(permissions)
    test.deepEqual(objToMap, accessToken.services[kRtmServiceType].__permissions)
    test.done()
}

