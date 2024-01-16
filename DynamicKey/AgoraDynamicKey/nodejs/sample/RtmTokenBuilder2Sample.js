const RtmTokenBuilder = require("../src/RtmTokenBuilder2").RtmTokenBuilder;

// Need to set environment variable AGORA_APP_ID
const appId = process.env.AGORA_APP_ID;
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = process.env.AGORA_APP_CERTIFICATE;

const userId = "test_user_id";
const expirationInSeconds = 3600;

const token = RtmTokenBuilder.buildToken(appId, appCertificate, userId, expirationInSeconds);
console.log("Rtm Token: " + token);
