package io.agora.chat;

import io.agora.media.AccessToken2;

public class ChatTokenBuilder2 {

    /**
     * Build the CHAT user token.
     *
     * @param appId:          The App ID issued to you by Agora. Apply for a new App ID from
     *                        Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate: Certificate of the application that you registered in
     *                        the Agora Dashboard. See Get an App Certificate.
     * @param uuid:           The Agora Chat user's uuid, see {//to do:add link to 获取用户详细信息}.
     *                        optionalUid must be unique.
     * @param expire:         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                        Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The USER token.
     */
    public String buildUserToken(String appId, String appCertificate, String uuid, int expire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        AccessToken2.Service serviceChat = new AccessToken2.ServiceChat(uuid);

        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER, expire);
        accessToken.addService(serviceChat);

        try {
            return accessToken.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
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
     *                        Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The APP token.
     */
    public String buildAppToken(String appId, String appCertificate, int expire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        AccessToken2.Service serviceChat = new AccessToken2.ServiceChat();

        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_APP, expire);
        accessToken.addService(serviceChat);

        try {
            return accessToken.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}
