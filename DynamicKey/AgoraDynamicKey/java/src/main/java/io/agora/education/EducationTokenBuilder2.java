package io.agora.education;

import io.agora.media.AccessToken2;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class EducationTokenBuilder2 {

    /**
     * build user room token
     * @param appId
     * @param appCertificate
     * @param roomUuid
     * @param userUuid
     * @param role
     * @param expire
     * @return
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
     * @param appId
     * @param appCertificate
     * @param userUuid
     * @param expire
     * @return
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
     * @param appId
     * @param appCertificate
     * @param expire
     * @return
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
