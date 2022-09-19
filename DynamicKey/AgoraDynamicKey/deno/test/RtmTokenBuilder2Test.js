/**
 * run this test with command:
 * nodeunit test/RtmTokenBuilder2Test.js
 * see https://github.com/caolan/nodeunit
 */
import { RtmTokenBuilder } from "../src/RtmTokenBuilder2.js";
import { AccessToken2, ServiceRtm, kRtmServiceType } from "../src/AccessToken2.js";
import {assert, assertThrows} from "https://deno.land/std/testing/asserts.ts";

const appId = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const userId = "test_user";
const expire = 600;

Deno.test('buildToken', (test) => {
    let token = RtmTokenBuilder.buildToken(appId, appCertificate, userId, expire);
    let accessToken = new AccessToken2("", "", 0, 0);
    accessToken.from_string(token);

    assert(appId === accessToken.appId);
    assert(expire === accessToken.expire);
    assert(userId === accessToken.services[kRtmServiceType].__user_id);
    assert(expire === accessToken.services[kRtmServiceType].__privileges[ServiceRtm.kPrivilegeLogin]);
})
