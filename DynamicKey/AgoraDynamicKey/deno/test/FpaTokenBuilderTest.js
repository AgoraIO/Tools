/**
 * run this test with command:
 * nodeunit test/FpaTokenBuilderTest.js
 * see https://github.com/caolan/nodeunit
 */
import { FpaTokenBuilder } from '../src/FpaTokenBuilder.js'
import { AccessToken2, ServiceFpa, kFpaServiceType } from '../src/AccessToken2.js'
import {assert, assertThrows} from "https://deno.land/std/testing/asserts.ts";

const appId = "970CA35de60c44645bbae8a215061b33"
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
const expire = 24 * 3600

Deno.test('buildToken_Test', (test) => {
    let token = FpaTokenBuilder.buildToken(appId, appCertificate)
    let accessToken = new AccessToken2('', '', 0, 0)
    accessToken.from_string(token)

    assert(appId === accessToken.appId);
    assert(expire === accessToken.expire);
    assert(0 === accessToken.services[kFpaServiceType].__privileges[ServiceFpa.kPrivilegeLogin]);
})
