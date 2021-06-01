<?php

require_once "../src/AccessToken2.php";
require_once "../src/RtmTokenBuilder2.php";

class RtmTokenBuilder2Test
{
    public $appId = "970CA35de60c44645bbae8a215061b33";
    public $appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    public $expire = 600;
    public $userId = "test_user";

    public function run()
    {
        $this->test_buildToken();
    }

    public function test_buildToken()
    {
        $token = RtmTokenBuilder2::buildToken($this->appId, $this->appCertificate, $this->userId, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->userId, $accessToken->services[ServiceRtm::SERVICE_TYPE]->userId);
        Util::assertEqual(ServiceRtm::SERVICE_TYPE, $accessToken->services[ServiceRtm::SERVICE_TYPE]->type);
        Util::assertEqual($this->expire, $accessToken->services[ServiceRtm::SERVICE_TYPE]->privileges[ServiceRtm::PRIVILEGE_JOIN_LOGIN]);
    }
}

$rtmTokenBuilder2Test = new RtmTokenBuilder2Test();
$rtmTokenBuilder2Test->run();