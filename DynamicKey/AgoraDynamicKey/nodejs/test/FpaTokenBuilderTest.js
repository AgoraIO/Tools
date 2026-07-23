/**
 * run this test with command:
 * nodeunit test/FpaTokenBuilderTest.js
 * see https://github.com/caolan/nodeunit
 */
const FpaTokenBuilder = require('../src/FpaTokenBuilder').FpaTokenBuilder
const {AccessToken2, ServiceFpa, kFpaServiceType} = require('../src/AccessToken2')

const appId = "970CA35de60c44645bbae8a215061b33"
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
const expire = 24 * 3600

// Verifies FPA token generation and parsing.
exports.buildToken_Test = function (test) {
    let token = FpaTokenBuilder.buildToken(appId, appCertificate)
    let accessToken = new AccessToken2('', '', 0, 0)
    accessToken.from_string(token)

    test.equal(appId, accessToken.appId)
    test.equal(expire, accessToken.expire)
    test.equal(0, accessToken.getServices(kFpaServiceType)[0].__privileges[ServiceFpa.kPrivilegeLogin])
    test.done()
}
