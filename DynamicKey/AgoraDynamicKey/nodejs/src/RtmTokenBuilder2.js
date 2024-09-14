const AccessToken = require('../src/AccessToken2').AccessToken2
const ServiceRtm = require('../src/AccessToken2').ServiceRtm

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
}

module.exports.RtmTokenBuilder = RtmTokenBuilder
