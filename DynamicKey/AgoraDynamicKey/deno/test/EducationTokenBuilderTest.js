/**
 * run this test with command:
 * deno test test/EducationTokenBuilderTest.js
 */
import { EducationTokenBuilder } from '../src/EducationTokenBuilder.js'
import { AccessToken2, kApaasServiceType } from '../src/AccessToken2.js'
import { assert } from 'https://deno.land/std/testing/asserts.ts'
const appId = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const expire = 600
const roomUuid = '123'
const userUuid = '2882341273'
const role = 1

// Verifies Education room-user token generation and parsing.
Deno.test('BuildRoomUserToken_Test', () => {
    let accessToken = new AccessToken2('', '', 0, 0)
    let token = EducationTokenBuilder.buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire)
    accessToken.from_string(token)
    const service = accessToken.getServices(kApaasServiceType)[0]
    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
    assert(roomUuid === service.__room_uuid)
    assert(userUuid === service.__user_uuid)
    assert(role === service.__role)
})

// Verifies Education user token generation and parsing.
Deno.test('BuildUserToken_Test', () => {
    let accessToken = new AccessToken2('', '', 0, 0)
    let token = EducationTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expire)
    accessToken.from_string(token)
    const service = accessToken.getServices(kApaasServiceType)[0]

    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
    assert(userUuid === service.__user_uuid)
})

// Verifies Education application token generation and parsing.
Deno.test('BuildAppToken_Test', () => {
    let accessToken = new AccessToken2('', '', 0, 0)
    let token = EducationTokenBuilder.buildAppToken(appId, appCertificate, expire)
    accessToken.from_string(token)
    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
})
