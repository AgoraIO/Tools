package io.agora.media

/** Builds RTM and RTM2 Token007 tokens. */
class RtmTokenBuilder2 {
    /**
     * Build the RTM token.
     *
     * @param appId           The App ID issued to you by Agora. Apply for a new App ID from
     *                        Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate  Certificate of the application that you registered in
     *                        the Agora Dashboard. See Get an App Certificate.
     * @param userId          The user's account, max length is 64 Bytes.
     * @param tokenExpire     represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                        Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds).
     * @return The RTM token.
     */
    fun buildToken(appId: String, appCertificate: String, userId: String, tokenExpire: Int): String {
        val accessToken = AccessToken2(appId, appCertificate, tokenExpire)
        val serviceRtm = AccessToken2.ServiceRtm(userId)
        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, tokenExpire)
        accessToken.addService(serviceRtm)

        return try {
            accessToken.build()
        } catch (e: Exception) {
            e.printStackTrace()
            ""
        }
    }

    /**
     * Builds an RTM2 token with resource-level permissions.
     *
     * This special interface requires Agora assistance for proper usage.
     *
     * @param appId          The App ID issued to you by Agora.
     * @param appCertificate Certificate of the application registered in the Agora Dashboard.
     * @param userId         The user's account, max length is 64 bytes.
     * @param permissions    The RTM2 resource-level permissions.
     * @param expire         The number of seconds from now before the token expires.
     * @return The RTM2 token.
     */
    fun buildTokenWithPermissions(
        appId: String,
        appCertificate: String,
        userId: String,
        permissions: AccessToken2.ServiceRtm2.Permissions,
        expire: Int
    ): String {
        val accessToken = AccessToken2(appId, appCertificate, expire)
        val serviceRtm2 = AccessToken2.ServiceRtm2(userId, permissions)
        serviceRtm2.addPrivilegeRtm2(AccessToken2.PrivilegeRtm2.PRIVILEGE_LOGIN, expire)
        accessToken.addService(serviceRtm2)

        return try {
            accessToken.build()
        } catch (exception: Exception) {
            exception.printStackTrace()
            ""
        }
    }
}
