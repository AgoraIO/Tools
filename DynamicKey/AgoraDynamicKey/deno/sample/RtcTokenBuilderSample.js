import { RtcTokenBuilder, Role as RtcRole } from "../src/RtcTokenBuilder.js";

// Need to set environment variable AGORA_APP_ID
const appId = Deno.env.get("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = Deno.env.get("AGORA_APP_CERTIFICATE");

const channelName = "7d72365eb983485397e3e3f9d460bdda";
const uid = 2882341273;
const account = "2882341273";
const role = RtcRole.PUBLISHER;
const expirationTimeInSeconds = 3600;
const currentTimestamp = Math.floor(Date.now() / 1000);
const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

console.log("App Id:", appId);
console.log("App Certificate:", appCertificate);
if (appId == undefined || appId == "" || appCertificate == undefined || appCertificate == "") {
    console.log("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
    Deno.exit(1);
}

// Build token with uid
const tokenWithUid = RtcTokenBuilder.buildTokenWithUid(appId, appCertificate, channelName, uid, role, privilegeExpiredTs);
console.log("Token With Integer Number Uid:", tokenWithUid);

// Build token with user account
const tokenWithAccount = RtcTokenBuilder.buildTokenWithAccount(appId, appCertificate, channelName, account, role, privilegeExpiredTs);
console.log("Token With UserAccount:", tokenWithAccount);
