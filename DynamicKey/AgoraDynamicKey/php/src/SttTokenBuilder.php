<?php

require_once "AccessToken2.php";
require_once "RtcTokenBuilder2.php";

class SttTokenBuilder
{
    /**
     * Build a Token007 that carries RTC, RTM, and STT services.
     *
     * @param $appId The App ID issued to you by Agora.
     * @param $appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param $channelName Unique channel name for the AgoraRTC session in the string format.
     * @param $rtcAccount The RTC user's account, max length is 255 Bytes.
     * @param $rtcRole ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
     *                 ROLE_SUBSCRIBER: An audience member in a live-broadcast profile.
     * @param $rtcTokenExpire Represented by the number of seconds elapsed since now.
     * @param $joinChannelPrivilegeExpire Represented by the number of seconds elapsed since now.
     * @param $pubAudioPrivilegeExpire Represented by the number of seconds elapsed since now.
     * @param $pubVideoPrivilegeExpire Represented by the number of seconds elapsed since now.
     * @param $pubDataStreamPrivilegeExpire Represented by the number of seconds elapsed since now.
     * @param $rtmUserId The RTM user's account, max length is 255 Bytes.
     * @param $rtmTokenExpire Represented by the number of seconds elapsed since now.
     * @return The RTC, RTM, and STT token.
     */
    public static function buildToken(
        $appId,
        $appCertificate,
        $channelName,
        $rtcAccount,
        $rtcRole,
        $rtcTokenExpire,
        $joinChannelPrivilegeExpire,
        $pubAudioPrivilegeExpire,
        $pubVideoPrivilegeExpire,
        $pubDataStreamPrivilegeExpire,
        $rtmUserId,
        $rtmTokenExpire
    ) {
        $token = new AccessToken2($appId, $appCertificate, $rtcTokenExpire);
        $serviceRtc = new ServiceRtc($channelName, $rtcAccount);

        $serviceRtc->addPrivilege(ServiceRtc::PRIVILEGE_JOIN_CHANNEL, $joinChannelPrivilegeExpire);
        if ($rtcRole == RtcTokenBuilder2::ROLE_PUBLISHER) {
            $serviceRtc->addPrivilege(ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM, $pubAudioPrivilegeExpire);
            $serviceRtc->addPrivilege(ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM, $pubVideoPrivilegeExpire);
            $serviceRtc->addPrivilege(ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM, $pubDataStreamPrivilegeExpire);
        }
        $token->addService($serviceRtc);

        $serviceRtm = new ServiceRtm($rtmUserId);
        $serviceRtm->addPrivilege(ServiceRtm::PRIVILEGE_LOGIN, $rtmTokenExpire);
        $token->addService($serviceRtm);

        $token->addService(new ServiceStt());

        return $token->build();
    }
}
