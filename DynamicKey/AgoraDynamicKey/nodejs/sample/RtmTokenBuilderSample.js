const RtmTokenBuilder = require("../src/RtmTokenBuilder").RtmTokenBuilder;
const RtmRole = require("../src/RtmTokenBuilder").Role;
const Priviledges = require("../src/AccessToken").priviledges;

// Need to set environment variable AGORA_APP_ID
const appId = process.env.AGORA_APP_ID;
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = process.env.AGORA_APP_CERTIFICATE;

const account = "test_user_id";
const expirationTimeInSeconds = 3600;
const currentTimestamp = Math.floor(Date.now() / 1000);
const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

console.log("App Id:", appId);
console.log("App Certificate:", appCertificate);
if (appId == undefined || appId == "" || appCertificate == undefined || appCertificate == "") {
    console.log("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
    process.exit(1);
}

const token = RtmTokenBuilder.buildToken(appId, appCertificate, account, RtmRole, privilegeExpiredTs);
console.log("Rtm Token:", token);
