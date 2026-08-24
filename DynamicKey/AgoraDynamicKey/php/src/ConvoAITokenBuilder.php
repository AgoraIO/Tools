<?php

require_once "AccessToken2.php";
require_once "RtcTokenBuilder2.php";

class ConvoAITokenBuilder
{
    /**
     * Build a Token007 that carries RTC, RTM, and ConvoAI services.
     *
     * @param $appId The App ID issued to you by Agora.
     * @param $appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param $channelName Unique channel name for the AgoraRTC session in the string format.
     * @param $rtcAccount The RTC user's account, max length is 255 Bytes.
     * @param $rtcRole ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
     *                 ROLE_SUBSCRIBER: An audience member in a live-broadcast profile.
     * @param $rtcTokenExpire Represented by the number of seconds elapsed since now. This is the whole token
     * expiration. The whole token is invalid after this time, even if a privilege expiration time is later.
     * @param $joinChannelPrivilegeExpire Represented by the number of seconds elapsed since now. This value
     * must not exceed the token expiration value; otherwise, the privilege is limited by the token expiration
     * time.
     * @param $pubAudioPrivilegeExpire Represented by the number of seconds elapsed since now. This value must
     * not exceed the token expiration value; otherwise, the privilege is limited by the token expiration
     * time.
     * @param $pubVideoPrivilegeExpire Represented by the number of seconds elapsed since now. This value must
     * not exceed the token expiration value; otherwise, the privilege is limited by the token expiration
     * time.
     * @param $pubDataStreamPrivilegeExpire Represented by the number of seconds elapsed since now. This value
     * must not exceed the token expiration value; otherwise, the privilege is limited by the token expiration
     * time.
     * @param $rtmUserId The RTM user's account, max length is 255 Bytes.
     * @param $rtmTokenExpire Represented by the number of seconds elapsed since now. This value must not
     * exceed the RTC token expiration value; otherwise, the RTM login privilege is limited by the token
     * expiration time.
     * @return The RTC, RTM, and ConvoAI token.
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

        $token->addService(new ServiceConvoAI());

        return $token->build();
    }
}
