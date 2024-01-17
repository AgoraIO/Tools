import { RtmTokenBuilder } from "../src/RtmTokenBuilder2.js";

// Need to set environment variable AGORA_APP_ID
const appId = Deno.env.get("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = Deno.env.get("AGORA_APP_CERTIFICATE");

const userId = "test_user_id";
const expirationInSeconds = 3600;

console.log("App Id:", appId);
console.log("App Certificate:", appCertificate);
if (appId == undefined || appId == "" || appCertificate == undefined || appCertificate == "") {
    console.log("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
    Deno.exit(1);
}

const token = RtmTokenBuilder.buildToken(appId, appCertificate, userId, expirationInSeconds);
console.log("Rtm Token:", token);
