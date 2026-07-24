/**
 * run this test with command:
 * deno test test/FpaTokenBuilderTest.js
 */
import { FpaTokenBuilder } from '../src/FpaTokenBuilder.js'
import { AccessToken2, kFpaServiceType, ServiceFpa } from '../src/AccessToken2.js'
import { assert } from 'https://deno.land/std/testing/asserts.ts'

const appId = '970CA35de60c44645bbae8a215061b33'
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b'
const expire = 24 * 3600

// Verifies FPA token generation and parsing.
Deno.test('buildToken_Test', () => {
    let token = FpaTokenBuilder.buildToken(appId, appCertificate)
    let accessToken = new AccessToken2('', '', 0, 0)
    accessToken.from_string(token)
    const service = accessToken.getServices(kFpaServiceType)[0]

    assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
    assert(0 === service.__privileges[ServiceFpa.kPrivilegeLogin])
})
