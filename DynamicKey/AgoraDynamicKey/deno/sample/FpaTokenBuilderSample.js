import { FpaTokenBuilder } from "../src/FpaTokenBuilder.js";

// Need to set environment variable AGORA_APP_ID
const appID = Deno.env.get("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = Deno.env.get("AGORA_APP_CERTIFICATE");

let token = FpaTokenBuilder.buildToken(appID, appCertificate);
console.log("Token with FPA service: " + token);
