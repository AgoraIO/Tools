/**
 * run this test with command:
 * nodeunit test/RtcTokenBuilder2Test.js
 * see https://github.com/caolan/nodeunit
 */
const EduTokenBuilder = require("../src/EducationTokenBuilder").EducationTokenBuilder;
const { AccessToken2, ServiceEducation, kEducationServiceType } = require("../src/AccessToken2");

// Need to set environment variable AGORA_APP_ID
const appId = process.env.AGORA_APP_ID;
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = process.env.AGORA_APP_CERTIFICATE;

const expire = 600;
const roomUuid = "123";
const userUuid = "2882341273";
const role = 1;

console.log("App Id:", appId);
console.log("App Certificate:", appCertificate);
if (appId == undefined || appId == "" || appCertificate == undefined || appCertificate == "") {
    console.log("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
    process.exit(1);
}

const tokenRoomUserToken = EduTokenBuilder.buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire);
console.log("Build room user token:", tokenRoomUserToken);

const tokenUserToken = EduTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expire);
console.log("Build user token:", tokenUserToken);

const tokenAppToken = EduTokenBuilder.buildAppToken(appId, appCertificate, expire);
console.log("Build app token:", tokenAppToken);
