const RtmTokenBuilder = require('../src/RtmTokenBuilder').RtmTokenBuilder;
const RtmRole = require('../src/RtmTokenBuilder').Role;
const Priviledges = require('../src/AccessToken').priviledges;
const appID  = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const account = "test_user_id";

const expirationTimeInSeconds = 3600
const currentTimestamp = Math.floor(Date.now() / 1000)

const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds

const token = RtmTokenBuilder.buildToken(appID, appCertificate, account, RtmRole, privilegeExpiredTs);
console.log("Rtm Token: " + token);
