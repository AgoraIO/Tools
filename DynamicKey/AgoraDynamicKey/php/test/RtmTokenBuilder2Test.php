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
}

$rtmTokenBuilder2Test = new RtmTokenBuilder2Test();
$rtmTokenBuilder2Test->run();
