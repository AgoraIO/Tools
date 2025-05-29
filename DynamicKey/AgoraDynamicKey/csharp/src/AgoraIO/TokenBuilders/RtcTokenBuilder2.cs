namespace AgoraIO.Media
{
    public class RtcTokenBuilder2
    {
        public enum Role
        {
            /**
             * RECOMMENDED. Use this role for a voice/video call or a live broadcast, if
             * your scenario does not require authentication for
             * [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
             */
            RolePublisher = 1,

            /**
             * Only use this role if your scenario require authentication for
             * [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
             *
             * @note In order for this role to take effect, please contact our support team
             * to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
             * still has the same privileges as Role_Publisher.
             */
            RoleSubscriber = 2
        }

        /**
         * Build the RTC token with uid.
         *
         * @param appId:            The App ID issued to you by Agora. Apply for a new App ID from
         *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
         * @param appCertificate:   Certificate of the application that you registered in
         *                          the Agora Dashboard. See Get an App Certificate.
         * @param channelName:      Unique channel name for the AgoraRTC session in the string format
         * @param uid:              User ID. A 32-bit unsigned integer with a value ranging from 1 to (2^32-1).
         *                          uid must be unique.
         * @param role:             ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
         *                          ROLE_SUBSCRIBER: An audience(default) in a live-broadcast profile.
         * @param tokenExpire:     represented by the number of seconds elapsed since now. If, for example,
         *                          you want to access the Agora Service within 10 minutes after the token is generated,
         *                          set tokenExpire as 600(seconds).
         * @param privilegeExpire: represented by the number of seconds elapsed since now. If, for example,
         *                          you want to enable your privilege for 10 minutes, set privilegeExpire as 600(seconds).
         * @return The RTC token.
         */
        public static string buildTokenWithUid(string appId, string appCertificate, string channelName, uint uid, Role role, uint tokenExpire, uint privilegeExpire)
        {
            return buildTokenWithUserAccount(appId, appCertificate, channelName, AccessToken2.getUidStr(uid), role, tokenExpire, privilegeExpire);
        }

        /**
         * Generates an RTC token with the specified privilege.
         * <p>
         * This method supports generating a token with the following privileges:
         * - Joining an RTC channel.
         * - Publishing audio in an RTC channel.
         * - Publishing video in an RTC channel.
         * - Publishing data streams in an RTC channel.
         * <p>
         * The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
         * enabled co-host authentication.
         * <p>
         * A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
         * The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
         * or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
         * the respective timestamp for each privilege in your app logic. After receiving the callback, you need
         * to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
         * the channel.
         *
         * @note Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
         * Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
         * When the token for joining the channel expires, the user is immediately kicked off the RTC channel
         * and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
         *
         * @param appId                        The App ID of your Agora project.
         * @param appCertificate               The App Certificate of your Agora project.
         * @param channelName                  The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
         *                                     - All lowercase English letters: a to z.
         *                                     - All uppercase English letters: A to Z.
         *                                     - All numeric characters: 0 to 9.
         *                                     - The space character.
         *                                     - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
         * @param uid                          The user ID. A 32-bit unsigned integer with a value range from 1 to (2^32 - 1). It must be unique. Set uid as 0, if you do not want to authenticate the user ID, that is, any uid from the app client can join the channel.
         * @param tokenExpire                  represented by the number of seconds elapsed since now. If, for example, you want to access the
         *                                     Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds).
         * @param joinChannelPrivilegeExpire   represented by the number of seconds elapsed since now.
         *                                     If, for example, you want to join channel and expect stay in the channel for 10 minutes, set joinChannelPrivilegeExpire as 600(seconds).
         * @param pubAudioPrivilegeExpire      represented by the number of seconds elapsed since now.
         *                                     If, for example, you want to enable publish audio privilege for 10 minutes, set pubAudioPrivilegeExpire as 600(seconds).
         * @param pubVideoPrivilegeExpire      represented by the number of seconds elapsed since now.
         *                                     If, for example, you want to enable publish video privilege for 10 minutes, set pubVideoPrivilegeExpire as 600(seconds).
         * @param pubDataStreamPrivilegeExpire represented by the number of seconds elapsed since now.
         *                                     If, for example, you want to enable publish data stream privilege for 10 minutes, set pubDataStreamPrivilegeExpire as 600(seconds).
         * @return The RTC token.
         */
        public static string buildTokenWithUid(string appId, string appCertificate, string channelName, uint uid,
                                        uint tokenExpire, uint joinChannelPrivilegeExpire, uint pubAudioPrivilegeExpire,
                                        uint pubVideoPrivilegeExpire, uint pubDataStreamPrivilegeExpire)
        {
            return buildTokenWithUserAccount(appId, appCertificate, channelName, AccessToken2.getUidStr(uid),
                    tokenExpire, joinChannelPrivilegeExpire, pubAudioPrivilegeExpire, pubVideoPrivilegeExpire, pubDataStreamPrivilegeExpire);
        }

        /**
         * Build the RTC token with account.
         *
         * @param appId:            The App ID issued to you by Agora. Apply for a new App ID from
         *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
         * @param appCertificate:   Certificate of the application that you registered in
         *                          the Agora Dashboard. See Get an App Certificate.
         * @param channelName:      Unique channel name for the AgoraRTC session in the string format
         * @param account:          The user's account, max length is 255 Bytes.
         * @param role:             ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
         *                          ROLE_SUBSCRIBER: An audience(default) in a live-broadcast profile.
         * @param tokenExpire:     represented by the number of seconds elapsed since now. If, for example,
         *                          you want to access the Agora Service within 10 minutes after the token is generated,
         *                          set tokenExpire as 600(seconds).
         * @param privilegeExpire: represented by the number of seconds elapsed since now. If, for example,
         *                          you want to enable your privilege for 10 minutes, set privilegeExpire as 600(seconds).
         * @return The RTC token.
         */
        public static string buildTokenWithUserAccount(string appId, string appCertificate, string channelName, string account, Role role, uint tokenExpire, uint privilegeExpire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, tokenExpire);
            AccessToken2.Service serviceRtc = new AccessToken2.ServiceRtc(channelName, account);

            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_JOIN_CHANNEL, privilegeExpire);
            if (Role.RolePublisher == role)
            {
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_AUDIO_STREAM, privilegeExpire);
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_VIDEO_STREAM, privilegeExpire);
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_DATA_STREAM, privilegeExpire);
            }
            accessToken.addService(serviceRtc);

            return accessToken.build();
        }

        /**
         * Generates an RTC token with the specified privilege.
         * <p>
         * This method supports generating a token with the following privileges:
         * - Joining an RTC channel.
         * - Publishing audio in an RTC channel.
         * - Publishing video in an RTC channel.
         * - Publishing data streams in an RTC channel.
         * <p>
         * The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
         * enabled co-host authentication.
         * <p>
         * A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
         * The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
         * or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
         * the respective timestamp for each privilege in your app logic. After receiving the callback, you need
         * to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
         * the channel.
         *
         * @note Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
         * Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
         * When the token for joining the channel expires, the user is immediately kicked off the RTC channel
         * and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
         *
         * @param appId                        The App ID of your Agora project.
         * @param appCertificate               The App Certificate of your Agora project.
         * @param channelName                  The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
         *                                     - All lowercase English letters: a to z.
         *                                     - All uppercase English letters: A to Z.
         *                                     - All numeric characters: 0 to 9.
         *                                     - The space character.
         *                                     - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
         * @param account                      The user account.
         * @param tokenExpire                  represented by the number of seconds elapsed since now. If, for example, you want to access the
         *                                     Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds).
         * @param joinChannelPrivilegeExpire   represented by the number of seconds elapsed since now.
         *                                     If, for example, you want to join channel and expect stay in the channel for 10 minutes, set joinChannelPrivilegeExpire as 600(seconds).
         * @param pubAudioPrivilegeExpire      represented by the number of seconds elapsed since now.
         *                                     If, for example, you want to enable publish audio privilege for 10 minutes, set pubAudioPrivilegeExpire as 600(seconds).
         * @param pubVideoPrivilegeExpire      represented by the number of seconds elapsed since now.
         *                                     If, for example, you want to enable publish video privilege for 10 minutes, set pubVideoPrivilegeExpire as 600(seconds).
         * @param pubDataStreamPrivilegeExpire represented by the number of seconds elapsed since now.
         *                                     If, for example, you want to enable publish data stream privilege for 10 minutes, set pubDataStreamPrivilegeExpire as 600(seconds).
         * @return The RTC token.
         */
        public static string buildTokenWithUserAccount(string appId, string appCertificate, string channelName, string account,
                                                uint tokenExpire, uint joinChannelPrivilegeExpire, uint pubAudioPrivilegeExpire,
                                                uint pubVideoPrivilegeExpire, uint pubDataStreamPrivilegeExpire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, tokenExpire);
            AccessToken2.Service serviceRtc = new AccessToken2.ServiceRtc(channelName, account);

            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_JOIN_CHANNEL, joinChannelPrivilegeExpire);
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_AUDIO_STREAM, pubAudioPrivilegeExpire);
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_VIDEO_STREAM, pubVideoPrivilegeExpire);
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_DATA_STREAM, pubDataStreamPrivilegeExpire);
            accessToken.addService(serviceRtc);

            return accessToken.build();
        }

        /**
         * Build the RTC and RTM token with account.
         *
         * @param appId:            The App ID issued to you by Agora. Apply for a new App ID from
         *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
         * @param appCertificate:   Certificate of the application that you registered in
         *                          the Agora Dashboard. See Get an App Certificate.
         * @param channelName:      Unique channel name for the AgoraRTC session in the string format
         * @param account:          The user's account, max length is 255 Bytes.
         * @param role:             ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
         *                          ROLE_SUBSCRIBER: An audience(default) in a live-broadcast profile.
         * @param tokenExpire:      represented by the number of seconds elapsed since now. If, for example,
         *                          you want to access the Agora Service within 10 minutes after the token is generated,
         *                          set tokenExpire as 600(seconds).
         * @param privilegeExpire: represented by the number of seconds elapsed since now. If, for example,
         *                          you want to enable your privilege for 10 minutes, set privilegeExpire as 600(seconds).
         * @return The RTC and RTM token.
         */
        public static string buildTokenWithRtm(string appId, string appCertificate, string channelName, string account, Role role, uint tokenExpire, uint privilegeExpire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, tokenExpire);
            AccessToken2.Service serviceRtc = new AccessToken2.ServiceRtc(channelName, account);

            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_JOIN_CHANNEL, privilegeExpire);
            if (Role.RolePublisher == role)
            {
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_AUDIO_STREAM, privilegeExpire);
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_VIDEO_STREAM, privilegeExpire);
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_DATA_STREAM, privilegeExpire);
            }
            accessToken.addService(serviceRtc);

            AccessToken2.Service serviceRtm = new AccessToken2.ServiceRtm(account);

            serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtmEnum.PRIVILEGE_LOGIN, tokenExpire);
            accessToken.addService(serviceRtm);

            return accessToken.build();
        }

        /**
         * Build the RTC and RTM token with account.
         *
         * @param appId:                        The App ID issued to you by Agora. Apply for a new App ID from
         *                                      Agora Dashboard if it is missing from your kit. See Get an App ID.
         * @param appCertificate:               Certificate of the application that you registered in
         *                                      the Agora Dashboard. See Get an App Certificate.
         * @param channelName:                  Unique channel name for the AgoraRTC session in the string format
         * @param rtcAccount:                   The RTC user's account, max length is 255 Bytes.
         * @param rtcRole:                      ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
         *                                      ROLE_SUBSCRIBER: An audience(default) in a live-broadcast profile.
         * @param rtcTokenExpire:               represented by the number of seconds elapsed since now.
         *                                      If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set rtcTokenExpire as 600(seconds).
         * @param joinChannelPrivilegeExpire:   represented by the number of seconds elapsed since now.
         *                                      If, for example, you want to join channel and expect stay in the channel for 10 minutes, set joinChannelPrivilegeExpire as 600(seconds).
         * @param pubAudioPrivilegeExpire:      represented by the number of seconds elapsed since now.
         *                                      If, for example, you want to enable publish audio privilege for 10 minutes, set pubAudioPrivilegeExpire as 600(seconds).
         * @param pubVideoPrivilegeExpire:      represented by the number of seconds elapsed since now.
         *                                      If, for example, you want to enable publish video privilege for 10 minutes, set pubVideoPrivilegeExpire as 600(seconds).
         * @param pubDataStreamPrivilegeExpire: represented by the number of seconds elapsed since now.
         *                                      If, for example, you want to enable publish data stream privilege for 10 minutes, set pubDataStreamPrivilegeExpire as 600(seconds).
         * @param rtmUserId:                    The RTM user's account, max length is 255 Bytes.
         * @param rtmTokenExpire:               represented by the number of seconds elapsed since now.
                                                If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set rtmTokenExpire as 600(seconds).
         * @return The RTC and RTM token.
         */
        public static string buildTokenWithRtm2(string appId, string appCertificate, string channelName, string rtcAccount, Role rtcRole, uint rtcTokenExpire,
            uint joinChannelPrivilegeExpire, uint pubAudioPrivilegeExpire, uint pubVideoPrivilegeExpire, uint pubDataStreamPrivilegeExpire, string rtmUserId, uint rtmTokenExpire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, rtcTokenExpire);
            AccessToken2.Service serviceRtc = new AccessToken2.ServiceRtc(channelName, rtcAccount);

            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_JOIN_CHANNEL, joinChannelPrivilegeExpire);
            if (Role.RolePublisher == rtcRole)
            {
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_AUDIO_STREAM, pubAudioPrivilegeExpire);
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_VIDEO_STREAM, pubVideoPrivilegeExpire);
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_DATA_STREAM, pubDataStreamPrivilegeExpire);
            }
            accessToken.addService(serviceRtc);

            AccessToken2.Service serviceRtm = new AccessToken2.ServiceRtm(rtmUserId);

            serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtmEnum.PRIVILEGE_LOGIN, rtmTokenExpire);
            accessToken.addService(serviceRtm);

            return accessToken.build();
        }
    }
}
