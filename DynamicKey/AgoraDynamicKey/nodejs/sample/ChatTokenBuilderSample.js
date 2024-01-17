const ChatTokenBuilder = require("../src/ChatTokenBuilder").ChatTokenBuilder;

// Need to set environment variable AGORA_APP_ID
const appId = process.env.AGORA_APP_ID;
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = process.env.AGORA_APP_CERTIFICATE;

const userUuid = "a7180cb0-1d4a-11ed-9210-89ff47c9da5e";
const expirationInSeconds = 600;

console.log("App Id:", appId);
console.log("App Certificate:", appCertificate);
if (appId == undefined || appId == "" || appCertificate == undefined || appCertificate == "") {
    console.log("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
    process.exit(1);
}

const userToken = ChatTokenBuilder.buildUserToken(appId, appCertificate, userUuid, expirationInSeconds);
console.log("Chat User Token:", userToken);

const appToken = ChatTokenBuilder.buildAppToken(appId, appCertificate, expirationInSeconds);
console.log("Chat App Token:", appToken);
