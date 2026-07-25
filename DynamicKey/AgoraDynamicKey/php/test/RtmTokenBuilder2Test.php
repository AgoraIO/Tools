<?php

require_once "../src/AccessToken2.php";
require_once "../src/RtmTokenBuilder2.php";

class RtmTokenBuilder2Test
{
    public $appId = "970CA35de60c44645bbae8a215061b33";
    public $appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    public $expire = 600;
    public $userId = "test_user";

    /**
     * Run all RTM token builder test cases.
     */
    public function run()
    {
        $this->test_buildToken();
        $this->test_buildTokenWithPermissions();
    }

    /**
     * Verify RTM token generation and parsing.
     */
    public function test_buildToken()
    {
        $token = RtmTokenBuilder2::buildToken($this->appId, $this->appCertificate, $this->userId, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);
        $serviceRtm = $accessToken->getServices(ServiceRtm::SERVICE_TYPE)[0];

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->userId, $serviceRtm->userId);
        Util::assertEqual(ServiceRtm::SERVICE_TYPE, $serviceRtm->type);
        Util::assertEqual($this->expire, $serviceRtm->privileges[ServiceRtm::PRIVILEGE_LOGIN]);
    }

    /**
     * Verify RTM2 permission token generation, parsing, and signature validation.
     */
    public function test_buildTokenWithPermissions()
    {
        $permissions = new Rtm2Permissions();
        $permissions->add(Rtm2Permissions::MESSAGE_CHANNELS, Rtm2Permissions::READ, ["message-a", "message-b"]);
        $permissions->add(Rtm2Permissions::STREAM_CHANNELS, Rtm2Permissions::WRITE, ["stream-a"]);

        $token = RtmTokenBuilder2::buildTokenWithPermissions(
            $this->appId, $this->appCertificate, $this->userId, $permissions, $this->expire
        );
        $accessToken = new AccessToken2();

        Util::assertEqual(true, $accessToken->parse($token));
        Util::assertEqual(true, $accessToken->verifySignature($this->appCertificate));
        $service = $accessToken->getServices(ServiceRtm2::SERVICE_TYPE)[0];
        Util::assertEqual($this->userId, $service->userId);
        Util::assertEqual(json_encode($permissions->details), json_encode($service->permissions->details));
        Util::assertEqual($this->expire, $service->privileges[ServiceRtm2::PRIVILEGE_LOGIN]);
    }
}

$rtmTokenBuilder2Test = new RtmTokenBuilder2Test();
$rtmTokenBuilder2Test->run();
