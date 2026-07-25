package io.agora.media

class RtmTokenBuilder2 {
    /**
     * Build the RTM token with userId.
     *
     * @param appId:          The App ID issued to you by Agora. Apply for a new App ID from
     *                        Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate: Certificate of the application that you registered in
     *                        the Agora Dashboard. See Get an App Certificate.
     * @param userId:         The user's account, max length is 64 Bytes.
     * @param tokenExpire:    represented by the number of seconds elapsed since now. If, for example,
     *                        you want to access the Agora Service within 10 minutes after the token is generated,
     *                        set tokenExpire as 600(seconds).
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
}
