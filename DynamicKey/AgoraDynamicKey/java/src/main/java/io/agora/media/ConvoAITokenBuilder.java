package io.agora.media;

/**
 * Builds ConvoAI tokens with RTC and RTM services.
 */
public class ConvoAITokenBuilder {
    /**
     * Builds a ConvoAI token with RTC and RTM services using a token expiration of 86400 seconds and a
     * privilege expiration of 0.
     * @param appId The App ID issued to you by Agora.
     * @param appCertificate Certificate of the application registered in the Agora Dashboard.
     * @param channelName The unique channel name for the Agora RTC session in string format. The string length
     * must be less than 64 bytes. The channel name may contain the following characters:
     * - All lowercase English letters: a to z.
     * - All uppercase English letters: A to Z.
     * - All numeric characters: 0 to 9.
     * - The space character.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param account The account used by both RTC and RTM, max length is 255 bytes.
     * @return The ConvoAI token.
     */
    public static String buildToken(String appId, String appCertificate, String channelName, String account) {
        return buildToken(appId, appCertificate, channelName, account, 86400, 0);
    }

    /**
     * Builds a ConvoAI token with RTC and RTM services using a privilege expiration of 0.
     * @param appId The App ID issued to you by Agora.
     * @param appCertificate Certificate of the application registered in the Agora Dashboard.
     * @param channelName The unique channel name for the Agora RTC session in string format. The string length
     * must be less than 64 bytes. The channel name may contain the following characters:
     * - All lowercase English letters: a to z.
     * - All uppercase English letters: A to Z.
     * - All numeric characters: 0 to 9.
     * - The space character.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param account The account used by both RTC and RTM, max length is 255 bytes.
     * @param tokenExpire The whole token lifetime in seconds from now.
     * @return The ConvoAI token.
     */
    public static String buildToken(String appId, String appCertificate, String channelName, String account,
                                    int tokenExpire) {
        return buildToken(appId, appCertificate, channelName, account, tokenExpire, 0);
    }

    /**
     * Builds a ConvoAI token with RTC and RTM services.
     * @param appId The App ID issued to you by Agora.
     * @param appCertificate Certificate of the application registered in the Agora Dashboard.
     * @param channelName The unique channel name for the Agora RTC session in string format. The string length
     * must be less than 64 bytes. The channel name may contain the following characters:
     * - All lowercase English letters: a to z.
     * - All uppercase English letters: A to Z.
     * - All numeric characters: 0 to 9.
     * - The space character.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param account The account used by both RTC and RTM, max length is 255 bytes.
     * @param tokenExpire The whole token lifetime in seconds from now.
     * @param privilegeExpire The RTC and RTM privilege lifetime in seconds from now. It must not exceed
     * tokenExpire; otherwise, it is limited by the token expiration time.
     * @return The ConvoAI token.
     */
    public static String buildToken(String appId, String appCertificate, String channelName, String account,
                                    int tokenExpire, int privilegeExpire) {
        return buildTokenWithPrivilege(
                appId, appCertificate, channelName, account, RtcTokenBuilder2.Role.ROLE_PUBLISHER,
                tokenExpire, privilegeExpire, privilegeExpire, privilegeExpire, privilegeExpire,
                account, privilegeExpire);
    }

    /**
     * Builds a ConvoAI token with RTC and RTM services.
     *
     * @param appId The App ID issued to you by Agora.
     * @param appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param channelName The unique channel name for the Agora RTC session in string format. The string length
     * must be less than 64 bytes. The channel name may contain the following characters:
     * - All lowercase English letters: a to z.
     * - All uppercase English letters: A to Z.
     * - All numeric characters: 0 to 9.
     * - The space character.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
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
     * @return The ConvoAI token.
     */
    public static String buildTokenWithPrivilege(String appId, String appCertificate, String channelName, String rtcAccount,
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
