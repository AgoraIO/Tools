package io.agora.rtm;

import io.agora.media.AccessToken2;

public class RtmTokenBuilder2 {

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
    public String buildToken(String appId, String appCertificate, String userId, int expire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        AccessToken2.Service serviceRtm = new AccessToken2.ServiceRtm(userId);

        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire);
        accessToken.addService(serviceRtm);

        try {
            return accessToken.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * Builds an RTM2 token with resource-level permissions.
     *
     * <p>This special interface requires Agora assistance for proper usage.</p>
     *
     * @param appId The App ID issued to you by Agora.
     * @param appCertificate Certificate of the application registered in the Agora Dashboard.
     * @param userId The user's account, max length is 64 bytes.
     * @param permissions The RTM2 resource-level permissions.
     * @param expire The number of seconds from now before the token expires.
     * @return The RTM2 token.
     */
    public String buildTokenWithPermissions(String appId, String appCertificate, String userId,
                                            AccessToken2.ServiceRtm2.Permissions permissions, int expire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        AccessToken2.Service serviceRtm2 = new AccessToken2.ServiceRtm2(userId, permissions);
        serviceRtm2.addPrivilegeRtm2(AccessToken2.PrivilegeRtm2.PRIVILEGE_LOGIN, expire);
        accessToken.addService(serviceRtm2);

        try {
            return accessToken.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}
