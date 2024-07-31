/**
 * run this test with command:
 * nodeunit AccessTokenTest.js
 * see https://github.com/caolan/nodeunit
 */
const { AccessToken2, ServiceRtc, ServiceRtm, ServiceChat } = require('../src/AccessToken2')

var appID = '970CA35de60c44645bbae8a215061b33'
var appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
var channel = '7d72365eb983485397e3e3f9d460bdda'
var uid = 2882341273
var uidStr = '2882341273'
var ts = 1111111
var expire = 600
var salt = 1
var user_id = 'test_user'

exports.AccessToken_Test = function (test) {
    var expected =
        '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let rtc_service = new ServiceRtc(channel, uid)
    rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtc_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

// test uid = 0
exports.AccessToken_Test2 = function (test) {
    var expected =
        '007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo='

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let rtc_service = new ServiceRtc(channel, 0)
    rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtc_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

// test service rtc account
exports.AccessToken_Test3 = function (test) {
    var expected =
        '007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj'

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let rtc_service = new ServiceRtc(channel, `${uid}`)
    rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    token.add_service(rtc_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

// test service multi service
exports.AccessToken_Test4 = function (test) {
    var expected =
        '007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmBgYGVgYGMF8JjDJDCZZwKQCg3mKuZGxmWlqkqWFsYmFqbGleapxqnGaZYqJmUFSSkoiF4ORhYWRsYmhkbkxyCyISZwMJanFJfGlxalFACKnKng='

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let rtc_service = new ServiceRtc(channel, uid)
    rtc_service.add_privilege(ServiceRtc.kPrivilegeJoinChannel, expire)
    rtc_service.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, expire)
    rtc_service.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, expire)
    rtc_service.add_privilege(ServiceRtc.kPrivilegePublishDataStream, expire)
    token.add_service(rtc_service)

    let rtm_service = new ServiceRtm(user_id)
    rtm_service.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
    token.add_service(rtm_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

exports.AccessToken_Test_buildChatUserToken = function (test) {
    var expected =
        '007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrAyMDIxgPheDkYWFkbGJoZG5MQAfpR64'

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let chat_service = new ServiceChat(uidStr)
    chat_service.add_privilege(ServiceChat.kPrivilegeUser, expire)
    token.add_service(chat_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}

exports.AccessToken_Test_buildChatAppToken = function (test) {
    var expected =
        '007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZGRgZmMB8BgYArfIYaw=='

    var token = new AccessToken2(appID, appCertificate, ts, expire)
    token.salt = salt
    let chat_service = new ServiceChat()
    chat_service.add_privilege(ServiceChat.kPrivilegeApp, expire)
    token.add_service(chat_service)

    var actual = token.build()
    test.equal(expected, actual)
    test.done()
}
