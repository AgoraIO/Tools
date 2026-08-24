package io.agora.media

/** Builds Token007 tokens for RTC, RTM, and STT services. */
class SttTokenBuilder {
    companion object {
        /**
         * Build a Token007 that carries RTC, RTM, and STT services.
         *
         * rtcTokenExpire is the whole token expiration. The whole token is invalid after this time,
         * even if a privilege expiration time is later. RTC privilege expiration values and
         * rtmTokenExpire must not exceed rtcTokenExpire; otherwise, the privileges are limited by
         * the token expiration time.
         */
        fun buildToken(
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

            accessToken.addService(AccessToken2.ServiceStt())

            return accessToken.build()
        }
    }
}
