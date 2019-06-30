var AccessToken = require("../src/AccessToken").AccessToken;

class RtmTokenBuilder {
  constructor(appID, appCertificate, account) {
    this.key = new AccessToken(appID, appCertificate, account, 0);
  }

  buildToken() {
    return this.key.build();
  }

  initPrivileges(role) {
    let rolePri = RolePrivileges[role];
    this.key.messages = JSON.parse(JSON.stringify(rolePri));
  }

  initTokenBuilder(originToken) {
    return builder.key.fromString(originToken);
  }
  setPrivilege(privilege, expireTimestamp) {
    this.key.messages[privilege] = expireTimestamp;
  }

  removePrivilege(privilege) {
    delete this.key.messages[privilege];
  }
}

module.exports.RtmTokenBuilder = RtmTokenBuilder;
