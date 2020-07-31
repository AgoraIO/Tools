<?php

require_once "AccessToken2.php";

class RtcTokenBuilder2
{
    const ROLE_PUBLISHER = 1;
    const ROLE_SUBSCRIBER = 2;

    /**
     * Build the RTC token with uid.
     *
     * @param $appId :          The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param $appCertificate : Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param $channelName :    Unique channel name for the AgoraRTC session in the string format
     * @param $uid :            User ID. A 32-bit unsigned integer with a value ranging from 1 to (232-1).
     *                          optionalUid must be unique.
     * @param $role :           ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
     *                          ROLE_SUBSCRIBER: An audience(default) in a live-broadcast profile.
     * @param $expire :         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The RTC token.
     */
    public static function buildTokenWithUid($appId, $appCertificate, $channelName, $uid, $role, $expire)
    {
        return self::buildTokenWithAccount($appId, $appCertificate, $channelName, $uid, $role, $expire);
    }

    /**
     * Build the RTC token with account.
     *
     * @param $appId :          The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param $appCertificate : Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param $channelName :    Unique channel name for the AgoraRTC session in the string format
     * @param $account :        The user's account, max length is 255 Bytes.
     * @param $role :           ROLE_PUBLISHER: A broadcaster/host in a live-broadcast profile.
     *                          ROLE_SUBSCRIBER: An audience(default) in a live-broadcast profile.
     * @param $expire :         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expireTimestamp as 600(seconds).
     * @return The RTC token.
     */
    public static function buildTokenWithAccount($appId, $appCertificate, $channelName, $account, $role, $expire)
    {
        $accessToken = new AccessToken2($appId, $appCertificate, $expire);
        $serviceRtc = new ServiceRtc($channelName, $account);

        $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_JOIN_CHANNEL, $expire);
        if ($role == self::ROLE_PUBLISHER) {
            $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM, $expire);
            $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM, $expire);
            $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_PUBLISH_DATA_STREAM, $expire);
        }
        $accessToken->addService($serviceRtc);

        return $accessToken->build();
    }
}
