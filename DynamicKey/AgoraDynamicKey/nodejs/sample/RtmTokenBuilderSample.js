const RtmTokenBuilder = require('../src/RtmTokenBuilder').RtmTokenBuilder;
const RtmRole = require('../src/RtmTokenBuilder').Role;
const Priviledges = require('../src/AccessToken').priviledges;
const appID  = "b792b33fc5f046ffa22776bf8d140e4d";
const appCertificate = "cedaa9beef5c4378ad9675c4e0ca0af2";
const account = "265";

const expirationTimeInSeconds = 3600
const currentTimestamp = Math.floor(Date.now() / 1000)

const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds

const token = RtmTokenBuilder.buildToken(appID, appCertificate, account, RtmRole, privilegeExpiredTs);
console.log("Rtm Token: " + token);
