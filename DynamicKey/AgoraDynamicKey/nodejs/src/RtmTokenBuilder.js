const AccessToken = require("../src/AccessToken").AccessToken
const Priviledges = require('../src/AccessToken').priviledges

const Role = {
  Rtm_User: 1
}
class RtmTokenBuilder {

  /**
   * @param {*} appID: The App ID issued to you by Agora. Apply for a new App ID from 
   *       Agora Dashboard if it is missing from your kit. See Get an App ID.
   * @param {*} appCertificate:	Certificate of the application that you registered in 
   *                 the Agora Dashboard. See Get an App Certificate.
   * @param {*} account: The user account. 
   * @param {*} privilegeExpiredTs : represented by the number of seconds elapsed since 
   *                   1/1/1970. If, for example, you want to access the
   *                   Agora Service within 10 minutes after the token is 
   *                   generated, set expireTimestamp as the current 
   * @return token
   */
  static buildToken(appID, appCertificate, account, privilegeExpiredTs) {
    const key = new AccessToken(appID, appCertificate, '', account)
    key.addPriviledge(Priviledges.kRtmLogin, privilegeExpiredTs)
    return key.build()
  }
}

module.exports.RtmTokenBuilder = RtmTokenBuilder
module.exports.Role = Role