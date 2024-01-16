/**
 * run this test with command:
 * nodeunit test/RtcTokenBuilder2Test.js
 * see https://github.com/caolan/nodeunit
 */
import { EducationTokenBuilder } from "../src/EducationTokenBuilder.js";

// Need to set environment variable AGORA_APP_ID
const appId = Deno.env.get("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = Deno.env.get("AGORA_APP_CERTIFICATE");

const expire = 600;
const roomUuid = "123";
const userUuid = "2882341273";
const role = 1;

const tokenA = EducationTokenBuilder.buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire);
console.log("Build room user token: " + tokenA);
const tokenB = EducationTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expire);
console.log("Build user token " + tokenB);
const tokenC = EducationTokenBuilder.buildAppToken(appId, appCertificate, expire);
console.log("Build app token: " + tokenC);
