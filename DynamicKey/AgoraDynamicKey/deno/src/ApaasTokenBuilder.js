import { AccessToken2 as AccessToken, ServiceApaas, ServiceChat, ServiceRtm } from './AccessToken2.js'
import { Md5 } from 'https://deno.land/std@0.156.0/hash/md5.ts'

class ApaasTokenBuilder {
    /**
     * build user room token
     * @param appId             The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate    Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param roomUuid          The room's id, must be unique.
     * @param userUuid          The user's id, must be unique.
     * @param role              The user's role.
     * @param expire            represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The user room token.
     */
    static buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire) {
        let accessToken = new AccessToken(appId, appCertificate, 0, expire)

        let chatUserId = new Md5().update(userUuid).toString()
        let apaasService = new ServiceApaas(roomUuid, userUuid, role)
        accessToken.add_service(apaasService)

        let rtmService = new ServiceRtm(userUuid)
        rtmService.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
        accessToken.add_service(rtmService)

        let chatService = new ServiceChat(chatUserId)
        chatService.add_privilege(ServiceChat.kPrivilegeUser, expire)
        accessToken.add_service(chatService)

        return accessToken.build()
    }

    /**
     * build user token
     * @param appId             The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate    Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param userUuid          The user's id, must be unique.
     * @param expire            represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The user token.
     */
    static buildUserToken(appId, appCertificate, userUuid, expire) {
        let accessToken = new AccessToken(appId, appCertificate, 0, expire)
        let apaasService = new ServiceApaas('', userUuid)
        apaasService.add_privilege(ServiceApaas.PRIVILEGE_USER, expire)
        accessToken.add_service(apaasService)

        return accessToken.build()
    }

    /**
     * build app token
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The app token.
     */
    static buildAppToken(appId, appCertificate, expire) {
        let accessToken = new AccessToken(appId, appCertificate, 0, expire)
        let apaasService = new ServiceApaas()
        apaasService.add_privilege(ServiceApaas.PRIVILEGE_APP, expire)
        accessToken.add_service(apaasService)

        return accessToken.build()
    }
}

export { ApaasTokenBuilder }
