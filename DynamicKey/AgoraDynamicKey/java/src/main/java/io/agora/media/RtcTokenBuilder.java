package io.agora.media;

public class RtcTokenBuilder {
    public enum Role {
        /**
         * DEPRECATED. Role_Attendee has the same privileges as Role_Publisher.
         */
        Role_Attendee(0),
        /**
         *    RECOMMENDED. Use this role for a voice/video call or a live broadcast, if your scenario does not require authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
         */
        Role_Publisher(1),
        /**
         * Only use this role if your scenario require authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
         *
         * @note In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
         */
        Role_Subscriber(2),
        /**
         * DEPRECATED. Role_Attendee has the same privileges as Role_Publisher.
         */
        Role_Admin(101);

        public int initValue;

        Role(int initValue) {
            this.initValue = initValue;
        }
    }

    /**
     * Builds an RTC token using an int uid.
     *
     * @param appId The App ID issued to you by Agora.
     * @param appCertificate Certificate of the application that you registered in
     *        the Agora Dashboard.
     * @param channelName The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
     * <ul>
     *    <li> The 26 lowercase English letters: a to z.</li>
     *    <li> The 26 uppercase English letters: A to Z.</li>
     *    <li> The 10 digits: 0 to 9.</li>
     *    <li> The space.</li>
     *    <li> "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * </ul>
     * @param uid  User ID. A 32-bit unsigned integer with a value ranging from
     *        1 to (2^32-1).
     * @param role The user role.
     * <ul>
     *     <li> Role_Publisher = 1: RECOMMENDED. Use this role for a voice/video call or a live broadcast.</li>
     *     <li> Role_Subscriber = 2: ONLY use this role if your live-broadcast scenario requires authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in). In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.</li>
     * </ul>
     * @param privilegeTs Represented by the number of seconds elapsed since 1/1/1970.
     *        If, for example, you want to access the Agora Service within 10 minutes
     *        after the token is generated, set expireTimestamp as the current time stamp
     *        + 600 (seconds).
     */
    public String buildTokenWithUid(String appId, String appCertificate,
                                    String channelName, int uid, Role role, int privilegeTs) {
        String account = uid == 0 ? "" : String.valueOf(uid & 0xFFFFFFFFL);
        return buildTokenWithUserAccount(appId, appCertificate, channelName,
                account, role, privilegeTs);
    }

    /**
     * Builds an RTC token using a string userAccount.
     *
     * @param appId The App ID issued to you by Agora.
     * @param appCertificate Certificate of the application that you registered in
     *        the Agora Dashboard.
     * @param channelName The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
     * <ul>
     *    <li> The 26 lowercase English letters: a to z.</li>
     *    <li> The 26 uppercase English letters: A to Z.</li>
     *    <li> The 10 digits: 0 to 9.</li>
     *    <li> The space.</li>
     *    <li> "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * </ul>
     * @param account  The user account.
     * @param role The user role.
     * <ul>
     *     <li> Role_Publisher = 1: RECOMMENDED. Use this role for a voice/video call or a live broadcast.</li>
     *     <li> Role_Subscriber = 2: ONLY use this role if your live-broadcast scenario requires authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in). In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.</li>
     * </ul>
     * @param privilegeTs represented by the number of seconds elapsed since 1/1/1970.
     *        If, for example, you want to access the Agora Service within 10 minutes
     *        after the token is generated, set expireTimestamp as the current time stamp
     *        + 600 (seconds).
     */
    public String buildTokenWithUserAccount(String appId, String appCertificate,
                                            String channelName, String account, Role role, int privilegeTs) {

        // Assign appropriate access privileges to each role.
        AccessToken builder = new AccessToken(appId, appCertificate, channelName, account);
        builder.addPrivilege(AccessToken.Privileges.kJoinChannel, privilegeTs);
        if (role == Role.Role_Publisher || role == Role.Role_Attendee || role == Role.Role_Admin) {
            builder.addPrivilege(AccessToken.Privileges.kPublishAudioStream, privilegeTs);
            builder.addPrivilege(AccessToken.Privileges.kPublishVideoStream, privilegeTs);
            builder.addPrivilege(AccessToken.Privileges.kPublishDataStream, privilegeTs);
        }

        try {
            return builder.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    /**
     * Generates an RTC token with the specified privilege.
     *
     * This method supports generating a token with the following privileges:
     * - Joining an RTC channel.
     * - Publishing audio in an RTC channel.
     * - Publishing video in an RTC channel.
     * - Publishing data streams in an RTC channel.
     *
     * The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
     * enabled co-host authentication.
     *
     * A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
     * The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
     * or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
     * the respective timestamp for each privilege in your app logic. After receiving the callback, you need
     * to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
     * the channel.
     *
     * @note
     * Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
     * Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
     * When the token for joining the channel expires, the user is immediately kicked off the RTC channel
     * and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
     *
     * @param appId The App ID of your Agora project.
     * @param appCertificate The App Certificate of your Agora project.
     * @param channelName The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
     * - All lowercase English letters: a to z.
     * - All uppercase English letters: A to Z.
     * - All numeric characters: 0 to 9.
     * - The space character.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param uid The user ID. A 32-bit unsigned integer with a value range from 1 to (232 - 1). It must be unique. Set uid as 0, if you do not want to authenticate the user ID, that is, any uid from the app client can join the channel.
     * @param joinChannelPrivilegeExpiredTs The Unix timestamp when the privilege for joining the channel expires, represented
     * by the sum of the current timestamp plus the valid time period of the token. For example, if you set joinChannelPrivilegeExpiredTs as the
     * current timestamp plus 600 seconds, the token expires in 10 minutes.
     * @param pubAudioPrivilegeExpiredTs The Unix timestamp when the privilege for publishing audio expires, represented
     * by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubAudioPrivilegeExpiredTs as the
     * current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
     * set pubAudioPrivilegeExpiredTs as the current Unix timestamp.
     * @param pubVideoPrivilegeExpiredTs The Unix timestamp when the privilege for publishing video expires, represented
     * by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubVideoPrivilegeExpiredTs as the
     * current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
     * set pubVideoPrivilegeExpiredTs as the current Unix timestamp.
     * @param pubDataStreamPrivilegeExpiredTs The Unix timestamp when the privilege for publishing data streams expires, represented
     * by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubDataStreamPrivilegeExpiredTs as the
     * current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
     * set pubDataStreamPrivilegeExpiredTs as the current Unix timestamp.
     */
    public String buildTokenWithUid(String appId, String appCertificate,
                                    String channelName, int uid, int joinChannelPrivilegeExpiredTs,
                                    int pubAudioPrivilegeExpiredTs, int pubVideoPrivilegeExpiredTs,
                                    int pubDataStreamPrivilegeExpiredTs) {
        String account = uid == 0 ? "" : String.valueOf(uid & 0xFFFFFFFFL);
        return buildTokenWithUserAccount(appId, appCertificate, channelName,
                account, joinChannelPrivilegeExpiredTs, pubAudioPrivilegeExpiredTs,
                pubVideoPrivilegeExpiredTs, pubDataStreamPrivilegeExpiredTs);
    }

    /**
     * Generates an RTC token with the specified privilege.
     *
     * This method supports generating a token with the following privileges:
     * - Joining an RTC channel.
     * - Publishing audio in an RTC channel.
     * - Publishing video in an RTC channel.
     * - Publishing data streams in an RTC channel.
     *
     * The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
     * enabled co-host authentication.
     *
     * A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
     * The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
     * or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
     * the respective timestamp for each privilege in your app logic. After receiving the callback, you need
     * to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
     * the channel.
     *
     * @note
     * Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
     * Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
     * When the token for joining the channel expires, the user is immediately kicked off the RTC channel
     * and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
     *
     * @param appId The App ID of your Agora project.
     * @param appCertificate The App Certificate of your Agora project.
     * @param channelName The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
     * - All lowercase English letters: a to z.
     * - All uppercase English letters: A to Z.
     * - All numeric characters: 0 to 9.
     * - The space character.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param account The user account.
     * @param joinChannelPrivilegeExpiredTs The Unix timestamp when the privilege for joining the channel expires, represented
     * by the sum of the current timestamp plus the valid time period of the token. For example, if you set joinChannelPrivilegeExpiredTs as the
     * current timestamp plus 600 seconds, the token expires in 10 minutes.
     * @param pubAudioPrivilegeExpiredTs The Unix timestamp when the privilege for publishing audio expires, represented
     * by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubAudioPrivilegeExpiredTs as the
     * current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
     * set pubAudioPrivilegeExpiredTs as the current Unix timestamp.
     * @param pubVideoPrivilegeExpiredTs The Unix timestamp when the privilege for publishing video expires, represented
     * by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubVideoPrivilegeExpiredTs as the
     * current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
     * set pubVideoPrivilegeExpiredTs as the current Unix timestamp.
     * @param pubDataStreamPrivilegeExpiredTs The Unix timestamp when the privilege for publishing data streams expires, represented
     * by the sum of the current timestamp plus the valid time period of the token. For example, if you set pubDataStreamPrivilegeExpiredTs as the
     * current timestamp plus 600 seconds, the token expires in 10 minutes. If you do not want to enable this privilege,
     * set pubDataStreamPrivilegeExpiredTs as the current Unix timestamp.
     */
    public String buildTokenWithUserAccount(String appId, String appCertificate,
                                            String channelName, String account, int joinChannelPrivilegeExpiredTs,
                                            int pubAudioPrivilegeExpiredTs, int pubVideoPrivilegeExpiredTs,
                                            int pubDataStreamPrivilegeExpiredTs) {
        // Assign appropriate access privileges to each role.
        AccessToken builder = new AccessToken(appId, appCertificate, channelName, account);
        builder.addPrivilege(AccessToken.Privileges.kJoinChannel, joinChannelPrivilegeExpiredTs);
        builder.addPrivilege(AccessToken.Privileges.kPublishAudioStream, pubAudioPrivilegeExpiredTs);
        builder.addPrivilege(AccessToken.Privileges.kPublishVideoStream, pubVideoPrivilegeExpiredTs);
        builder.addPrivilege(AccessToken.Privileges.kPublishDataStream, pubDataStreamPrivilegeExpiredTs);
        try {
            return builder.build();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
}