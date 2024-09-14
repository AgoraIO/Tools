package io.agora.education;

import io.agora.media.AccessToken2;
import io.agora.media.Utils;

public class EducationTokenBuilder2 {
    /**
     * build user room token
     *
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param roomUuid       The room's id, must be unique.
     * @param userUuid       The user's id, must be unique.
     * @param role           The user's role.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The user room token.
     */
    public String buildRoomUserToken(String appId, String appCertificate, String roomUuid, String userUuid, Short role, int expire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        String chatUserId = Utils.md5(userUuid);

        AccessToken2.Service serviceApaas = new AccessToken2.ServiceApaas(roomUuid, userUuid, role);
        serviceApaas.addPrivilegeApaas(AccessToken2.PrivilegeApaas.PRIVILEGE_ROOM_USER, expire);
        accessToken.addService(serviceApaas);

        AccessToken2.Service serviceRtm = new AccessToken2.ServiceRtm(userUuid);
        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire);
        accessToken.addService(serviceRtm);

        AccessToken2.Service serviceChat = new AccessToken2.ServiceChat(chatUserId);
        serviceRtm.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER, expire);
        accessToken.addService(serviceChat);

        try {
            return accessToken.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * build user token
     *
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param userUuid       The user's id, must be unique.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The user token.
     */
    public String buildUserToken(String appId, String appCertificate, String userUuid, int expire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        AccessToken2.Service service = new AccessToken2.ServiceApaas(userUuid);

        service.addPrivilegeApaas(AccessToken2.PrivilegeApaas.PRIVILEGE_USER, expire);
        accessToken.addService(service);

        try {
            return accessToken.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * build app token
     *
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The app token.
     */
    public String buildAppToken(String appId, String appCertificate, int expire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        AccessToken2.Service serviceApaas = new AccessToken2.ServiceApaas();

        serviceApaas.addPrivilegeApaas(AccessToken2.PrivilegeApaas.PRIVILEGE_APP, expire);
        accessToken.addService(serviceApaas);

        try {
            return accessToken.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}
