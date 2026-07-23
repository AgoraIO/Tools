/**
 * run this test with command:
 * deno test test/RtmTokenBuilder2Test.js
 */
import { RtmTokenBuilder } from '../src/RtmTokenBuilder2.js'
import { AccessToken2, kRtmServiceType, ServiceRtm } from '../src/AccessToken2.js'
import { assert } from 'https://deno.land/std/testing/asserts.ts'

const appId = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const userId = 'test_user'
const expire = 600

// Verifies RTM Token007 generation and parsing.
Deno.test('buildToken', () => {
    let token = RtmTokenBuilder.buildToken(appId, appCertificate, userId, expire)
    let accessToken = new AccessToken2('', '', 0, 0)
    accessToken.from_string(token)
    const service = accessToken.getServices(kRtmServiceType)[0]

    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
    assert(userId === service.__user_id)
    assert(expire === service.__privileges[ServiceRtm.kPrivilegeLogin])
})
