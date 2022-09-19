/**
 * run this test with command:
 * nodeunit test/EducationTokenBuilderTest.js
 * see https://github.com/caolan/nodeunit
 */
import { EducationTokenBuilder as EduTokenBuilder} from '../src/EducationTokenBuilder.js'
import { AccessToken2, kEducationServiceType } from '../src/AccessToken2.js'
import {assert, assertThrows} from "https://deno.land/std/testing/asserts.ts";
const appId = "970CA35de60c44645bbae8a215061b33"
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
const expire = 600
const roomUuid = "123";
const userUuid = "2882341273";
const role = 1;

Deno.test('BuildRoomUserToken_Test', (test) => {
   let accessToken = new AccessToken2('', '', 0, 0)
   let token = EduTokenBuilder.buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire)
   accessToken.from_string(token)
   assert(appId === accessToken.appId)
    assert(expire === accessToken.expire)
   assert(roomUuid===accessToken.services[kEducationServiceType].__room_uuid)
   assert(userUuid===accessToken.services[kEducationServiceType].__user_uuid)
   assert(role===accessToken.services[kEducationServiceType].__role)
})
 
Deno.test('BuildUserToken_Test', (test) => {
   let accessToken = new AccessToken2('', '', 0, 0)
   let token = EduTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expire)
   accessToken.from_string(token)

   assert(appId===accessToken.appId)
   assert(expire===accessToken.expire)
   assert(userUuid===accessToken.services[kEducationServiceType].__user_uuid)
 })
 
 Deno.test('BuildAppToken_Test', (test) => {
   let accessToken = new AccessToken2('', '', 0, 0)
   let token = EduTokenBuilder.buildAppToken(appId, appCertificate, expire)
   accessToken.from_string(token)
   assert(appId===accessToken.appId)
   assert(expire===accessToken.expire)
 })
