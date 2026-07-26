import { AccessToken2 as AccessToken, ServiceRtm, ServiceRtm2 } from '../src/AccessToken2.js'

class RtmTokenBuilder {
    /**
     * Build the RTM token.
     *
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from
     * Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     * the Agora Dashboard. See Get an App Certificate.
     * @param userId The user's account, max length is 64 Bytes.
     * @param expire represented by the number of seconds elapsed since now. If, for example, you want to access the
     * Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The RTM token.
     */
    static buildToken(appId, appCertificate, userId, expire) {
        let token = new AccessToken(appId, appCertificate, null, expire)

        let serviceRtm = new ServiceRtm(userId)
        serviceRtm.add_privilege(ServiceRtm.kPrivilegeLogin, expire)
        token.add_service(serviceRtm)

        return token.build()
    }

    /**
     * Build an RTM2 token with resource-level permissions.
     *
     * This special interface requires Agora assistance for proper usage.
     *
     * @param appId The App ID issued to you by Agora.
     * @param appCertificate Certificate of the application registered in the Agora Dashboard.
     * @param userId The user's account, max length is 64 bytes.
     * @param permissions The RTM2 resource-level permissions.
     * @param expire The number of seconds from now before the token expires.
     * @return The RTM2 token.
     */
    static buildTokenWithPermissions(appId, appCertificate, userId, permissions, expire) {
        const token = new AccessToken(appId, appCertificate, null, expire)
        const serviceRtm2 = new ServiceRtm2(userId, permissions)
        serviceRtm2.add_privilege(ServiceRtm2.kPrivilegeLogin, expire)
        token.add_service(serviceRtm2)
        return token.build()
    }
}

export { RtmTokenBuilder }
