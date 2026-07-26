/**
 * run this test with command:
 * deno test test/AccessTokenTest.js
 */
import { AccessToken, priviledges as Priviledges } from '../src/AccessToken.js'
import { assert } from 'https://deno.land/std/testing/asserts.ts'
import { Role as RtcRole, RtcTokenBuilder } from '../src/RtcTokenBuilder.js'

const appID = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const channel = '7d72365eb983485397e3e3f9d460bdda'
const uid = 2882341273
const salt = 1
const ts = 1111111
const expireTimestamp = 1446455471

// Verifies deterministic legacy RTC token generation.
Deno.test('AccessToken_Test', () => {
    const expected = '006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW'

    const key = new AccessToken(appID, appCertificate, channel, uid)
    key.salt = salt
    key.ts = ts
    key.messages[Priviledges.kJoinChannel] = expireTimestamp

    const actual = key.build()
    assert(expected === actual)
})

// Verifies deterministic legacy RTC token generation with an empty user ID.
Deno.test('AccessToken_Test2', () => {
    const expected = '006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW'

    const uid_zero = 0
    const key = new AccessToken(appID, appCertificate, channel, uid_zero)
    key.salt = salt
    key.ts = ts
    key.messages[Priviledges.kJoinChannel] = expireTimestamp

    const actual = key.build()
    assert(expected === actual)
})

// Verifies legacy publisher RTC token generation.
Deno.test('RtcTokenBuilder_Test', () => {
    const appID = '970CA35de60c44645bbae8a215061b33'
    const certificate = '5CFd2fd1755d40ecb72977518be15d3b'
    const expected =
        '006970CA35de60c44645bbae8a215061b33IACMv3I+fsRSejxy6luEwzA/1t/zbEHWfJCJ5m8ssFP/fLdIfRBXoFHlIgABAAAAR/QQAAQAAQCvKDdWAgCvKDdWAwCvKDdWBACvKDdW'

    const channelName = '7d72365eb983485397e3e3f9d460bdda'

    const uid = 2882341273

    const salt = 1

    const ts = 1111111

    const privilegeExpiredsTs = 1446455471

    const role = RtcRole.PUBLISHER

    const key = new AccessToken(appID, certificate, channelName, uid)
    key.addPriviledge(Priviledges.kJoinChannel, privilegeExpiredsTs)
    key.salt = salt
    key.ts = ts
    if (role == RtcRole.PUBLISHER || role == RtcRole.SUBSCRIBER || role == RtcRole.ADMIN) {
        key.addPriviledge(Priviledges.kPublishAudioStream, privilegeExpiredsTs)
        key.addPriviledge(Priviledges.kPublishVideoStream, privilegeExpiredsTs)
        key.addPriviledge(Priviledges.kPublishDataStream, privilegeExpiredsTs)
    }
    const actual = key.build()
    assert(expected === actual)
})

// Verifies legacy token parsing and malformed input handling.
Deno.test('AccessToken_Parse_Test', () => {
    const key = new AccessToken(appID, appCertificate, channel, uid)
    key.salt = salt
    key.ts = ts
    key.addPriviledge(Priviledges.kJoinChannel, expireTimestamp)
    const parsed = new AccessToken('', '', '', '')

    assert(parsed.fromString(key.build()))
    assert(parsed.messages[Priviledges.kJoinChannel] === expireTimestamp)
    assert(!parsed.fromString('007invalid'))
    assert(!parsed.fromString('006' + appID + '!'))
})

// Verifies both public legacy RTC builder entry points.
Deno.test('RtcTokenBuilder_PublicMethods_Test', () => {
    const uidToken = RtcTokenBuilder.buildTokenWithUid(
        appID, appCertificate, channel, uid, RtcRole.PUBLISHER, expireTimestamp)
    const accountToken = RtcTokenBuilder.buildTokenWithAccount(
        appID, appCertificate, channel, String(uid), RtcRole.SUBSCRIBER, expireTimestamp)

    assert(new AccessToken('', '', '', '').fromString(uidToken))
    assert(new AccessToken('', '', '', '').fromString(accountToken))
})
