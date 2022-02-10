package io.agora.education;

import io.agora.media.AccessToken2;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class EducationTokenBuilder2 {

    /**
     * build user room token
     * @param appId             The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate    Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param roomUuid          The room's id, must be unique.
     * @param userUuid          The user's id, must be unique.
     * @param role              The user's role, such as 0(invisible), 1(teacher), 2(student), 3(assistant), 4(observer) etc.
     * @param expire            represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The education user room token.
     */
    public String buildRoomUserToken(String appId, String appCertificate, String roomUuid, String userUuid, Integer role, int expire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        String chatUserId = md5(userUuid);

        AccessToken2.Service serviceEducation = new AccessToken2.ServiceEducation(roomUuid, userUuid, chatUserId, role);
        serviceEducation.addPrivilegeEducation(AccessToken2.PrivilegeEducation.PRIVILEGE_ROOM_USER, expire);
        accessToken.addService(serviceEducation);

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
     * build user individual token
     * @param appId             The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate    Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param userUuid          The user's id, must be unique.
     * @param expire            represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The education user token.
     */
    public String buildUserToken(String appId, String appCertificate, String userUuid, int expire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        AccessToken2.Service service = new AccessToken2.ServiceEducation(userUuid);

        service.addPrivilegeEducation(AccessToken2.PrivilegeEducation.PRIVILEGE_USER, expire);
        accessToken.addService(service);

        try {
            return accessToken.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * build app global token
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The education global token.
     */
    public String buildAppToken(String appId, String appCertificate, int expire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        AccessToken2.Service serviceEducation = new AccessToken2.ServiceEducation();

        serviceEducation.addPrivilegeEducation(AccessToken2.PrivilegeEducation.PRIVILEGE_APP, expire);
        accessToken.addService(serviceEducation);

        try {
            return accessToken.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    private String md5(String plainText) {
        byte[] secretBytes = null;
        try {
            secretBytes = MessageDigest.getInstance("md5").digest(
                    plainText.getBytes());
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("No md5 digest！");
        }
        String md5code = new BigInteger(1, secretBytes).toString(16);
        for (int i = 0; i < 32 - md5code.length(); i++) {
            md5code = "0" + md5code;
        }
        return md5code;
    }
}
