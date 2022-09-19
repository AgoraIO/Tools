/**
 * run this test with command:
 * nodeunit AccessTokenTest.js
 * see https://github.com/caolan/nodeunit
 */
import { AccessToken, priviledges as Priviledges} from "../src/AccessToken.js";
import { RtmTokenBuilder, Role } from "../src/RtmTokenBuilder.js";
import {assert, assertThrows} from "https://deno.land/std/testing/asserts.ts";

const appID = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const account = "test_user";
const expireTimestamp = 1446455471;

Deno.test('RtmToken_Test', (test) => {
    const token = RtmTokenBuilder.buildToken(appID, appCertificate, account, Role.Rtm_User, expireTimestamp);
    let accessToken = new AccessToken("", "", 0, 0);
    accessToken.fromString(token);

    assert(appID === accessToken.appID);
    assert(expireTimestamp === accessToken.messages[Priviledges.kRtmLogin]);
})
