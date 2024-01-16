import { RtmTokenBuilder, Role as RtmRole } from "../src/RtmTokenBuilder.js";

// Need to set environment variable AGORA_APP_ID
const appID = Deno.env.get("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = Deno.env.get("AGORA_APP_CERTIFICATE");

const account = "test_user_id";
const expirationTimeInSeconds = 3600;
const currentTimestamp = Math.floor(Date.now() / 1000);
const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

const token = RtmTokenBuilder.buildToken(appID, appCertificate, account, RtmRole, privilegeExpiredTs);
console.log("Rtm Token: " + token);
