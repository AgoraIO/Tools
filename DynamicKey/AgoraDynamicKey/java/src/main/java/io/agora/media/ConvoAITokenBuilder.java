package io.agora.media;

/**
 * Builds Token007 tokens for RTC, RTM, and ConvoAI services.
 */
public class ConvoAITokenBuilder {
    /**
     * Build a Token007 that carries RTC, RTM, and ConvoAI services.
     *
     * @param appId The App ID issued to you by Agora.
     * @param appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param channelName Unique channel name for the AgoraRTC session in the string format.
     * @param rtcAccount The RTC user's account, max length is 255 Bytes.
     * @param rtcRole ROLE_PUBLISHER: A broadcaster or host in a live-broadcast profile.
     *                ROLE_SUBSCRIBER: An audience member in a live-broadcast profile.
     * @param rtcTokenExpire Represented by the number of seconds elapsed since now. This is the whole token
     * expiration. The whole token is invalid after this time, even if a privilege expiration time is later.
     * @param joinChannelPrivilegeExpire Represented by the number of seconds elapsed since now. This value
     * must not exceed the token expiration value; otherwise, the privilege is limited by the token expiration
     * time.
     * @param pubAudioPrivilegeExpire Represented by the number of seconds elapsed since now. This value must
     * not exceed the token expiration value; otherwise, the privilege is limited by the token expiration
     * time.
     * @param pubVideoPrivilegeExpire Represented by the number of seconds elapsed since now. This value must
     * not exceed the token expiration value; otherwise, the privilege is limited by the token expiration
     * time.
     * @param pubDataStreamPrivilegeExpire Represented by the number of seconds elapsed since now. This value
     * must not exceed the token expiration value; otherwise, the privilege is limited by the token expiration
     * time.
     * @param rtmUserId The RTM user's account, max length is 255 Bytes.
     * @param rtmTokenExpire Represented by the number of seconds elapsed since now. This value must not
     * exceed the RTC token expiration value; otherwise, the RTM login privilege is limited by the token
     * expiration time.
     * @return The RTC, RTM, and ConvoAI token.
     */
    public static String buildToken(String appId, String appCertificate, String channelName, String rtcAccount,
                                    RtcTokenBuilder2.Role rtcRole, int rtcTokenExpire, int joinChannelPrivilegeExpire,
                                    int pubAudioPrivilegeExpire, int pubVideoPrivilegeExpire, int pubDataStreamPrivilegeExpire,
                                    String rtmUserId, int rtmTokenExpire) {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, rtcTokenExpire);
        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, rtcAccount);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, joinChannelPrivilegeExpire);
        if (rtcRole == RtcTokenBuilder2.Role.ROLE_PUBLISHER) {
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM, pubAudioPrivilegeExpire);
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_VIDEO_STREAM, pubVideoPrivilegeExpire);
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM, pubDataStreamPrivilegeExpire);
        }
        accessToken.addService(serviceRtc);

        AccessToken2.ServiceRtm serviceRtm = new AccessToken2.ServiceRtm(rtmUserId);
        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, rtmTokenExpire);
        accessToken.addService(serviceRtm);

        accessToken.addService(new AccessToken2.ServiceConvoAI());

        try {
            return accessToken.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}
