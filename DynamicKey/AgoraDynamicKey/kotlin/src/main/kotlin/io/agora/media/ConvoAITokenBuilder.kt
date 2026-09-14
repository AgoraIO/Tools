package io.agora.media

/** Builds ConvoAI tokens with RTC and RTM services. */
class ConvoAITokenBuilder {
    companion object {
        /**
         * Builds a ConvoAI token with RTC and RTM services.
         *
         * @param appId The App ID issued to you by Agora.
         * @param appCertificate Certificate of the application registered in the Agora Dashboard.
         * @param channelName The unique channel name for the Agora RTC session in string format. The string
         * length must be less than 64 bytes. The channel name may contain the following characters:
         * - All lowercase English letters: a to z.
         * - All uppercase English letters: A to Z.
         * - All numeric characters: 0 to 9.
         * - The space character.
         * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
         * @param account The account used by both RTC and RTM, max length is 255 bytes.
         * @param tokenExpire The whole token lifetime in seconds from now. Defaults to 86400.
         * @param privilegeExpire The RTC and RTM privilege lifetime in seconds from now. Defaults to 0 and
         * must not exceed tokenExpire; otherwise, it is limited by the token expiration time.
         * @return The ConvoAI token.
         */
        fun buildToken(
            appId: String,
            appCertificate: String,
            channelName: String,
            account: String,
            tokenExpire: Int = 86400,
            privilegeExpire: Int = 0
        ): String = buildTokenWithPrivilege(
            appId, appCertificate, channelName, account, RtcTokenBuilder2.Role.ROLE_PUBLISHER,
            tokenExpire, privilegeExpire, privilegeExpire, privilegeExpire, privilegeExpire,
            account, privilegeExpire
        )

        /**
         * Builds a ConvoAI token with RTC and RTM services.
         *
         * @param appId The App ID issued to you by Agora.
         * @param appCertificate Certificate of the application registered in the Agora Dashboard.
         * @param channelName The unique channel name for the Agora RTC session in string format. The string
         * length must be less than 64 bytes. The channel name may contain the following characters:
         * - All lowercase English letters: a to z.
         * - All uppercase English letters: A to Z.
         * - All numeric characters: 0 to 9.
         * - The space character.
         * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
         * @param rtcAccount The RTC user's account, max length is 255 bytes.
         * @param rtcRole ROLE_PUBLISHER for a broadcaster or ROLE_SUBSCRIBER for an audience member.
         * @param rtcTokenExpire Represented by the number of seconds elapsed since now. This is the whole
         * token expiration. The whole token is invalid after this time, even if a privilege expiration time
         * is later.
         * @param joinChannelPrivilegeExpire Represented by the number of seconds elapsed since now. This value
         * must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
         * @param pubAudioPrivilegeExpire Represented by the number of seconds elapsed since now. This value
         * must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
         * @param pubVideoPrivilegeExpire Represented by the number of seconds elapsed since now. This value
         * must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
         * @param pubDataStreamPrivilegeExpire Represented by the number of seconds elapsed since now. This
         * value must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
         * @param rtmUserId The RTM user's account, max length is 255 bytes.
         * @param rtmTokenExpire Represented by the number of seconds elapsed since now. This value must not
         * exceed rtcTokenExpire; otherwise, the RTM login privilege is limited by the token expiration time.
         * @return The ConvoAI token.
         */
        fun buildTokenWithPrivilege(
            appId: String,
            appCertificate: String,
            channelName: String,
            rtcAccount: String,
            rtcRole: RtcTokenBuilder2.Role,
            rtcTokenExpire: Int,
            joinChannelPrivilegeExpire: Int,
            pubAudioPrivilegeExpire: Int,
            pubVideoPrivilegeExpire: Int,
            pubDataStreamPrivilegeExpire: Int,
            rtmUserId: String,
            rtmTokenExpire: Int
        ): String {
            val accessToken = AccessToken2(appId, appCertificate, rtcTokenExpire)
            val serviceRtc = AccessToken2.ServiceRtc(channelName, rtcAccount)
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, joinChannelPrivilegeExpire)
            if (rtcRole == RtcTokenBuilder2.Role.ROLE_PUBLISHER) {
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM, pubAudioPrivilegeExpire)
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_VIDEO_STREAM, pubVideoPrivilegeExpire)
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM, pubDataStreamPrivilegeExpire)
            }
            accessToken.addService(serviceRtc)

            val serviceRtm = AccessToken2.ServiceRtm(rtmUserId)
            serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, rtmTokenExpire)
            accessToken.addService(serviceRtm)

            accessToken.addService(AccessToken2.ServiceConvoAI())

            return accessToken.build()
        }
    }
}
