const AccessToken = require('../src/AccessToken2').AccessToken2
const ServiceChat = require('../src/AccessToken2').ServiceChat

class ChatTokenBuilder {
    /**
     * Build the Chat user token.
     *
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from
     * Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     * the Agora Dashboard. See Get an App Certificate.
     * @param userUuid The user's id, must be unique.
     * @param expire represented by the number of seconds elapsed since now. If, for example, you want to access the
     * Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The Chat User token.
     */
    static buildUserToken(appId, appCertificate, userUuid, expire) {
        const token = new AccessToken(appId, appCertificate, null, expire)
        const serviceChat = new ServiceChat(userUuid)
        serviceChat.add_privilege(ServiceChat.kPrivilegeUser, expire)
        token.add_service(serviceChat)
        return token.build()
    }

    /**
     * Build the Chat App token.
     *
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from
     * Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     * the Agora Dashboard. See Get an App Certificate.
     * @param expire represented by the number of seconds elapsed since now. If, for example, you want to access the
     * Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The Chat App token.
     */
    static buildAppToken(appId, appCertificate, expire) {
        const token = new AccessToken(appId, appCertificate, null, expire)
        const serviceChat = new ServiceChat()
        serviceChat.add_privilege(ServiceChat.kPrivilegeApp, expire)
        token.add_service(serviceChat)
        return token.build()
    }
}

exports.ChatTokenBuilder = ChatTokenBuilder
