const AccessToken = require('../src/AccessToken2').AccessToken2
const ServiceEducation = require('../src/AccessToken2').ServiceEducation
const ServiceRtm = require('../src/AccessToken2').ServiceRtm
const ServiceChat = require('../src/AccessToken2').ServiceChat
const md5 = require("md5")


class EducationTokenBuilder {
    /**
     * build user room token
     * @param appId             The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate    Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param roomUuid          The room's id, must be unique.
     * @param userUuid          The user's id, must be unique.
     * @param role              The user's role, such as 0(invisible), 1(teacher), 2(student), 3(assistant), 4(observer) etc.
     * @param expire            represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The education user room token.
     */
    static buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire) {
        let accessToken = new AccessToken(appId, appCertificate, 0, expire)

        let chatUserId = md5(userUuid)
        let eduService = new ServiceEducation(roomUuid, userUuid, role)
        accessToken.add_service(eduService)

        let rtmService = new ServiceRtm(userUuid)
        rtmService.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
        accessToken.add_service(rtmService)

        let chatService = new ServiceChat(chatUserId)
        chatService.add_privilege(ServiceChat.kPrivilegeUser, expire)
        accessToken.add_service(chatService)

        return accessToken.build()
    }

    /**
     * build user individual token
     * @param appId             The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate    Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param userUuid          The user's id, must be unique.
     * @param expire            represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The education user token.
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
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The education global token.
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
