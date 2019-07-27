const  RTCTokenBuilder = require('../src/RTCTokenBuilder').RTCTokenBuilder;
const RTCRole = require('../src/RTCTokenBuilder').Role;
const  Priviledges = require('../src/AccessToken').priviledges;

const appID = '970CA35de60c44645bbae8a215061b33';
const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b';
const channelName = '7d72365eb983485397e3e3f9d460bdda';
const uid = 2882341273;
const account = "2882341273";
const role = RTCRole.PUBLISHER;

const privilegeExpiredTs = Math.floor((+Date.now() + 3600) / 1000)

const tokenA = RTCTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, role, privilegeExpiredTs);

console.log("Token With Integer Number Uid: "+tokenA)

const tokenB = RTCTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, account, role, privilegeExpiredTs);
console.log("Token With UserAccount: "+tokenB);
