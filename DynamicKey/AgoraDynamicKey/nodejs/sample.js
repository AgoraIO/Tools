const {RtcTokenBuilder, RtmTokenBuilder, RtcRole, RtmRole} = require('./index')

const generateRtcToken = () => {
  // Rtc Examples
  const appID = '970CA35de60c44645bbae8a215061b33';
  const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b';
  const channelName = '7d72365eb983485397e3e3f9d460bdda';
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
}


const generateRtmToken = () => {
  // Rtm Examples
  const appID  = "970CA35de60c44645bbae8a215061b33";
  const appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
  const account = "test_user_id";

  const expirationTimeInSeconds = 3600
  const currentTimestamp = Math.floor(Date.now() / 1000)

  const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds

  const token = RtmTokenBuilder.buildToken(appID, appCertificate, account, RtmRole, privilegeExpiredTs);
  console.log("Rtm Token: " + token);
}

generateRtcToken()
generateRtmToken()