const ChatTokenBuilder = require("../src/ChatTokenBuilder").ChatTokenBuilder;
const appId = "970CA35de60c44645bbae8a215061b33";
const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
const userUuid = "a7180cb0-1d4a-11ed-9210-89ff47c9da5e";
const expirationInSeconds = 600;

const userToken = ChatTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expirationInSeconds);
console.log("Chat User Token: " + userToken + "\n");

const appToken = ChatTokenBuilder.buildAppToken(appId, appCertificate, expirationInSeconds)
console.log("Chat App Token: " + appToken);