const FpaTokenBuilder = require("../src/FpaTokenBuilder").FpaTokenBuilder;

// Need to set environment variable AGORA_APP_ID
const appID = process.env.AGORA_APP_ID;
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = process.env.AGORA_APP_CERTIFICATE;

let token = FpaTokenBuilder.buildToken(appID, appCertificate);
console.log("Token with FPA service: " + token);
