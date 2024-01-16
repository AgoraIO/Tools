const RtmTokenBuilder = require("../src/RtmTokenBuilder").RtmTokenBuilder;
const RtmRole = require("../src/RtmTokenBuilder").Role;
const Priviledges = require("../src/AccessToken").priviledges;

// Need to set environment variable AGORA_APP_ID
const appID = process.env.AGORA_APP_ID;
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = process.env.AGORA_APP_CERTIFICATE;

const account = "test_user_id";
const expirationTimeInSeconds = 3600;
const currentTimestamp = Math.floor(Date.now() / 1000);
const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

const token = RtmTokenBuilder.buildToken(appID, appCertificate, account, RtmRole, privilegeExpiredTs);
console.log("Rtm Token: " + token);
