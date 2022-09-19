import {AccessToken2 as AccessToken, ServiceFpa} from '../src/AccessToken2.js'

class FpaTokenBuilder {
    /**
     * Build the FPA token.
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from
     * Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     * the Agora Dashboard. See Get an App Certificate.
     * @return The FPA token.
     */
    static buildToken(appId, appCertificate) {
        let token = new AccessToken(appId, appCertificate, 0, 24 * 3600)

        let serviceFpa = new ServiceFpa()
        serviceFpa.add_privilege(ServiceFpa.kPrivilegeLogin, 0)
        token.add_service(serviceFpa)

        return token.build()
    }
}

export {FpaTokenBuilder}
