const RtmTokenBuilder = require("../src/RtmTokenBuilder2").RtmTokenBuilder;
const appId = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const userId = "test_user_id";
const expirationInSeconds = 3600;

const token = RtmTokenBuilder.buildToken(appId, appCertificate, userId, expirationInSeconds);
console.log("Rtm Token: " + token);
