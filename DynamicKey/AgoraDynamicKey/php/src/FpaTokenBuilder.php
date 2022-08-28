<?php
require_once "AccessToken2.php";

class FpaTokenBuilder
{
    /**
     * Build the RTC token with uid.
     *
     * @param $appId The App ID issued to you by Agora. Apply for a new App ID from
     * Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param $appCertificate Certificate of the application that you registered in
     * the Agora Dashboard. See Get an App Certificate.
     * @return The RTC token.
     */
    public static function buildToken($appId, $appCertificate)
    {
        $token = new AccessToken2($appId, $appCertificate, 24 * 3600);
        $serviceFpa = new ServiceFpa();

        $serviceFpa->addPrivilege($serviceFpa::PRIVILEGE_LOGIN, 0);
        $token->addService($serviceFpa);

        return $token->build();
    }
}
