const RtcTokenBuilder = require('../src/RtcTokenBuilder').RtcTokenBuilder;
const RtcRole = require('../src/RtcTokenBuilder').Role;

const appID = '1ff2a19999bd457b82e823d5b69d3465';
const appCertificate = '2246825227f64a21abd056239ed77bed';
const channelName = '1081460522';
const uid = 2882341273;
const account = "2882341273";
const role = RtcRole.PUBLISHER;

const expirationTimeInSeconds = 3600

const currentTimestamp = Math.floor(Date.now() / 1000)

const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds

// IMPORTANT! Build token with either the uid or with the user account. Comment out the option you do not want to use below.

// Build token with uid
const tokenA = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, role, privilegeExpiredTs);
console.log("Token With Integer Number Uid: " + tokenA);

// Build token with user account
const tokenB = RtcTokenBuilder.buildTokenWithAccount(appID, appCertificate, channelName, account, role, privilegeExpiredTs);
console.log("Token With UserAccount: " + tokenB);
