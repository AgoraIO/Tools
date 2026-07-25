package io.agora.media

/** Builds APaaS room-user, user, and application Token007 tokens. */
class ApaasTokenBuilder {
    /**
     * build user room token
     *
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param roomUuid       The room's id, must be unique.
     * @param userUuid       The user's id, must be unique.
     * @param role           The user's role.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The user room token.
     */
    fun buildRoomUserToken(
        appId: String,
        appCertificate: String,
        roomUuid: String,
        userUuid: String,
        role: Short,
        expire: Int
    ): String {
        val accessToken = AccessToken2(appId, appCertificate, expire)

        val serviceApaas = AccessToken2.ServiceApaas(roomUuid, userUuid, role)
        serviceApaas.addPrivilegeApaas(AccessToken2.PrivilegeApaas.PRIVILEGE_ROOM_USER, expire)
        accessToken.addService(serviceApaas)

        val serviceRtm = AccessToken2.ServiceRtm(userUuid)
        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire)
        accessToken.addService(serviceRtm)

        val serviceChat = AccessToken2.ServiceChat(Utils.md5(userUuid))
        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER, expire)
        accessToken.addService(serviceChat)

        return accessToken.build()
    }

    /**
     * build user token
     *
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param userUuid       The user's id, must be unique.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The user token.
     */
    fun buildUserToken(appId: String, appCertificate: String, userUuid: String, expire: Int): String {
        val accessToken = AccessToken2(appId, appCertificate, expire)
        val serviceApaas = AccessToken2.ServiceApaas(userUuid)
        serviceApaas.addPrivilegeApaas(AccessToken2.PrivilegeApaas.PRIVILEGE_USER, expire)
        accessToken.addService(serviceApaas)
        return accessToken.build()
    }

    /**
     * build app token
     *
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The app token.
     */
    fun buildAppToken(appId: String, appCertificate: String, expire: Int): String {
        val accessToken = AccessToken2(appId, appCertificate, expire)
        val serviceApaas = AccessToken2.ServiceApaas()
        serviceApaas.addPrivilegeApaas(AccessToken2.PrivilegeApaas.PRIVILEGE_APP, expire)
        accessToken.addService(serviceApaas)
        return accessToken.build()
    }
}
