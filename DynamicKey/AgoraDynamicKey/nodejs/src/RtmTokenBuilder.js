const AccessToken = require("../src/AccessToken").AccessToken
const Priviledges = require('../src/AccessToken').priviledges

const Role = {
  Rtm_User: 1
}
class RtmTokenBuilder {

  static buildToken (appID, appCertificate, account, role, privilegeExpiredTs) {
    const key = new AccessToken(appID, appCertificate, account, "")
    key.addPriviledge(Priviledges.kRtmLogin, privilegeExpiredTs)
    return key.build()
  }
}

module.exports.RtmTokenBuilder = RtmTokenBuilder
module.exports.Role = Role