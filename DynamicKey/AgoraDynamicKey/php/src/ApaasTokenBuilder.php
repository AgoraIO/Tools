<?php

require_once "AccessToken2.php";

class ApaasTokenBuilder
{
    /**
     * Build room user token.
     *
     * @param $appId The App ID issued to you by Agora. Apply for a new App ID from
     *     Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param $appCertificate Certificate of the application that you registered in
     *     the Agora Dashboard. See Get an App Certificate.
     * @param $roomUuid The room's id, must be unique.
     * @param $userUuid The user's id, must be unique.
     * @param $role The user's role.
     * @param $expire represented by the number of seconds elapsed since now. If, for example, you want to access the
     *     Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The room user token.
     */
    public static function buildRoomUserToken($appId, $appCertificate, $roomUuid, $userUuid, $role, $expire)
    {
        $accessToken = new AccessToken2($appId, $appCertificate, $expire);

        $chatUserId = md5($userUuid);
        $serviceApaas = new ServiceApaas($roomUuid, $userUuid, $role);
        $serviceApaas->addPrivilege($serviceApaas::PRIVILEGE_ROOM_USER, $expire);
        $accessToken->addService($serviceApaas);

        $serviceRtm = new ServiceRtm($userUuid);
        $serviceRtm->addPrivilege($serviceRtm::PRIVILEGE_LOGIN, $expire);
        $accessToken->addService($serviceRtm);

        $serviceChat = new ServiceChat($chatUserId);
        $serviceChat->addPrivilege($serviceChat::PRIVILEGE_USER, $expire);
        $accessToken->addService($serviceChat);

        return $accessToken->build();
    }

    /**
     * Build user token.
     *
     * @param $appId The App ID issued to you by Agora. Apply for a new App ID from
     *     Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param $appCertificate Certificate of the application that you registered in
     *     the Agora Dashboard. See Get an App Certificate.
     * @param $userUuid The user's id, must be unique.
     * @param $expire represented by the number of seconds elapsed since now. If, for example, you want to access the
     *     Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The user token.
     */
    public static function buildUserToken($appId, $appCertificate, $userUuid, $expire)
    {
        $accessToken = new AccessToken2($appId, $appCertificate, $expire);
        $serviceApaas = new ServiceApaas("", $userUuid);
        $serviceApaas->addPrivilege($serviceApaas::PRIVILEGE_USER, $expire);
        $accessToken->addService($serviceApaas);

        return $accessToken->build();
    }

    /**
     * Build app token.
     *
     * @param $appId The App ID issued to you by Agora. Apply for a new App ID from
     *     Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param $appCertificate Certificate of the application that you registered in
     *     the Agora Dashboard. See Get an App Certificate.
     * @param $expire represented by the number of seconds elapsed since now. If, for example, you want to access the
     *     Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The app token.
     */
    public static function buildAppToken($appId, $appCertificate, $expire)
    {
        $accessToken = new AccessToken2($appId, $appCertificate, $expire);
        $serviceApaas = new ServiceApaas();
        $serviceApaas->addPrivilege($serviceApaas::PRIVILEGE_APP, $expire);
        $accessToken->addService($serviceApaas);

        return $accessToken->build();
    }
}
