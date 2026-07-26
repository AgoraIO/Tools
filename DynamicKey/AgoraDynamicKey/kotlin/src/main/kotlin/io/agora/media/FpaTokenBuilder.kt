package io.agora.media

/** Builds FPA Token007 tokens. */
class FpaTokenBuilder {
    /**
     * Build the FPA token.
     *
     * @param appId           The App ID issued to you by Agora. Apply for a new App ID from
     *                        Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate  Certificate of the application that you registered in
     *                        the Agora Dashboard. See Get an App Certificate.
     * @return The FPA token.
     */
    fun buildToken(appId: String, appCertificate: String): String {
        val accessToken = AccessToken2(appId, appCertificate, TOKEN_EXPIRE)
        val serviceFpa = AccessToken2.ServiceFpa()
        serviceFpa.addPrivilegeFpa(AccessToken2.PrivilegeFpa.PRIVILEGE_LOGIN, 0)
        accessToken.addService(serviceFpa)
        return accessToken.build()
    }

    private companion object {
        const val TOKEN_EXPIRE = 24 * 3600
    }
}
