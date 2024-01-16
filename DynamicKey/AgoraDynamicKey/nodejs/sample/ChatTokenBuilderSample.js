const ChatTokenBuilder = require("../src/ChatTokenBuilder").ChatTokenBuilder;

// Need to set environment variable AGORA_APP_ID
const appId = process.env.AGORA_APP_ID;
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = process.env.AGORA_APP_CERTIFICATE;

const userUuid = "a7180cb0-1d4a-11ed-9210-89ff47c9da5e";
const expirationInSeconds = 600;

const userToken = ChatTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expirationInSeconds);
console.log("Chat User Token: " + userToken + "\n");

const appToken = ChatTokenBuilder.buildAppToken(appId, appCertificate, expirationInSeconds);
console.log("Chat App Token: " + appToken);
