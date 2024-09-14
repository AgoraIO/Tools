namespace AgoraIO.Media
{
    public class RtmTokenBuilder2
    {
        /**
         * Build the RTM token.
         *
         * @param appId:          The App ID issued to you by Agora. Apply for a new App ID from
         *                        Agora Dashboard if it is missing from your kit. See Get an App ID.
         * @param appCertificate: Certificate of the application that you registered in
         *                        the Agora Dashboard. See Get an App Certificate.
         * @param userId:         The user's account, max length is 64 Bytes.
         * @param expire:         represented by the number of seconds elapsed since now. If, for example, you want to access the
         *                        Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
         * @return The RTM token.
         */
        public static string buildToken(string appId, string appCertificate, string userId, uint expire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            AccessToken2.Service serviceRtm = new AccessToken2.ServiceRtm(userId);

            serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtmEnum.PRIVILEGE_LOGIN, expire);
            accessToken.addService(serviceRtm);

            return accessToken.build();
        }
    }
}
