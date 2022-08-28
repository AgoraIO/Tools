/**
 * run this test with command:
 * nodeunit test/RtcTokenBuilder2Test.js
 * see https://github.com/caolan/nodeunit
 */
 const EduTokenBuilder = require('../src/EducationTokenBuilder').EducationTokenBuilder
 const {AccessToken2, ServiceEducation, kEducationServiceType} = require('../src/AccessToken2')
 const appId = "970CA35de60c44645bbae8a215061b33"
 const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
 const expire = 600
 const roomUuid = "123"
 const userUuid = "2882341273"
 const role = 1

const tokenA = EduTokenBuilder.buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire)
console.log("Build room user token: " + tokenA);
const tokenB = EduTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expire)
console.log("Build user token " + tokenB);
const tokenC = EduTokenBuilder.buildAppToken(appId, appCertificate, expire)
console.log("Build app token: " + tokenC);
 