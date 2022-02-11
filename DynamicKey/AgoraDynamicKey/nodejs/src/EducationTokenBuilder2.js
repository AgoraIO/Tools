const AccessToken = require('../src/AccessToken2').AccessToken2
const ServiceEducation = require('../src/AccessToken2').ServiceEducation
const ServiceRtm = require('../src/AccessToken2').ServiceRtm
const ServiceChat = require('../src/AccessToken2').ServiceChat
const md5 = require("md5")


class EducationTokenBuilder {
    /**
     * build user room token
     * @param appId
     * @param appCertificate
     * @param roomUuid
     * @param userUuid
     * @param role
     * @param expire
     * @return
     */
    static buildRoomUserToken(appId, appCertificate, roomUuid, userUuid,  role, expire) {
      let chatUserId = md5(userUuid);
      let accessToken = new AccessToken(appId, appCertificate, 0, expire)
      let eduService = new ServiceEducation(roomUuid, userUuid, chatUserId, role)
      accessToken.add_service(eduService)
      let rtmService = new ServiceRtm(userUuid)
      rtmService.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
      accessToken.add_service(rtmService)
      let chatService = new ServiceChat(userUuid)
      chatService.add_privilege(ServiceChat.kPrivilegeUser, expire)
      accessToken.add_service(chatService)
      return accessToken.build()
    }

    /**
     * build user individual token
     * @param appId
     * @param appCertificate
     * @param userUuid
     * @param expire
     * @return
     */
    static buildUserToken(appId, appCertificate, userUuid, expire) {
      let accessToken = new AccessToken(appId, appCertificate, 0, expire)
      let eduService = new ServiceEducation("", userUuid)
      eduService.add_privilege(ServiceEducation.PRIVILEGE_USER, expire)
      accessToken.add_service(eduService)
      return accessToken.build()
    }
    /**
     * build app global token
     * @param appId
     * @param appCertificate
     * @param expire
     * @return
     */
    static buildAppToken(appId, appCertificate, expire) {
      let accessToken = new AccessToken(appId, appCertificate, 0, expire)
      let eduService = new ServiceEducation()
      eduService.add_privilege(ServiceEducation.PRIVILEGE_APP, expire)
      accessToken.add_service(eduService)
      return accessToken.build()
    }
}

module.exports.EducationTokenBuilder = EducationTokenBuilder
