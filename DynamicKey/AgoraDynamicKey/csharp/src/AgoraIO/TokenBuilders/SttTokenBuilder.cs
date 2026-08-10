namespace AgoraIO.Media
{
    public class SttTokenBuilder
    {
        /**
         * Build a Token007 that carries RTC, RTM, and STT services.
         *
         * @param appId The App ID issued to you by Agora.
         * @param appCertificate Certificate of the application that you registered in the Agora Dashboard.
         * @param channelName Unique channel name for the AgoraRTC session in the string format.
         * @param rtcAccount The RTC user's account, max length is 255 Bytes.
         * @param rtcRole ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
         *                ROLE_SUBSCRIBER: An audience member in a live-broadcast profile.
         * @param rtcTokenExpire Represented by the number of seconds elapsed since now.
         * @param joinChannelPrivilegeExpire Represented by the number of seconds elapsed since now.
         * @param pubAudioPrivilegeExpire Represented by the number of seconds elapsed since now.
         * @param pubVideoPrivilegeExpire Represented by the number of seconds elapsed since now.
         * @param pubDataStreamPrivilegeExpire Represented by the number of seconds elapsed since now.
         * @param rtmUserId The RTM user's account, max length is 255 Bytes.
         * @param rtmTokenExpire Represented by the number of seconds elapsed since now.
         * @return The RTC, RTM, and STT token.
         */
        public static string buildToken(string appId, string appCertificate, string channelName, string rtcAccount, RtcTokenBuilder2.Role rtcRole,
            uint rtcTokenExpire, uint joinChannelPrivilegeExpire, uint pubAudioPrivilegeExpire, uint pubVideoPrivilegeExpire,
            uint pubDataStreamPrivilegeExpire, string rtmUserId, uint rtmTokenExpire)
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, rtcTokenExpire);
            AccessToken2.Service serviceRtc = new AccessToken2.ServiceRtc(channelName, rtcAccount);

            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_JOIN_CHANNEL, joinChannelPrivilegeExpire);
            if (RtcTokenBuilder2.Role.RolePublisher == rtcRole)
            {
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_AUDIO_STREAM, pubAudioPrivilegeExpire);
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_VIDEO_STREAM, pubVideoPrivilegeExpire);
                serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_DATA_STREAM, pubDataStreamPrivilegeExpire);
            }
            accessToken.addService(serviceRtc);

            AccessToken2.Service serviceRtm = new AccessToken2.ServiceRtm(rtmUserId);
            serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtmEnum.PRIVILEGE_LOGIN, rtmTokenExpire);
            accessToken.addService(serviceRtm);

            accessToken.addService(new AccessToken2.ServiceStt());

            return accessToken.build();
        }
    }
}
