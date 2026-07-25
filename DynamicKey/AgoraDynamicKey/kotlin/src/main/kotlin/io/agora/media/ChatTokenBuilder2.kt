package io.agora.media

/** Builds Chat user and application Token007 tokens. */
class ChatTokenBuilder2 {
    /**
     * Build the CHAT user token.
     *
     * @param appId:          The App ID issued to you by Agora. Apply for a new App ID from
     *                        Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate: Certificate of the application that you registered in
     *                        the Agora Dashboard. See Get an App Certificate.
     * @param userId:         The user's id, must be unique.
     * @param expire:         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                        Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The Chat User token.
     */
    fun buildUserToken(appId: String, appCertificate: String, userId: String, expire: Int): String {
        val accessToken = AccessToken2(appId, appCertificate, expire)
        val serviceChat = AccessToken2.ServiceChat(userId)
        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER, expire)
        accessToken.addService(serviceChat)

        return try {
            accessToken.build()
        } catch (e: Exception) {
            e.printStackTrace()
            ""
        }
    }

    /**
     * Build the CHAT app token.
     *
     * @param appId:          The App ID issued to you by Agora. Apply for a new App ID from
     *                        Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate: Certificate of the application that you registered in
     *                        the Agora Dashboard. See Get an App Certificate.
     * @param expire:         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                        Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The Chat App token.
     */
    fun buildAppToken(appId: String, appCertificate: String, expire: Int): String {
        val accessToken = AccessToken2(appId, appCertificate, expire)
        val serviceChat = AccessToken2.ServiceChat()
        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_APP, expire)
        accessToken.addService(serviceChat)

        return try {
            accessToken.build()
        } catch (e: Exception) {
            e.printStackTrace()
            ""
        }
    }
}
