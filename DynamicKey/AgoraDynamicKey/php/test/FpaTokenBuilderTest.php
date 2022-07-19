<?php
require_once "../src/AccessToken2.php";
require_once "../src/FpaTokenBuilder.php";

class FpaTokenBuilderTest
{
    public $appId = "970CA35de60c44645bbae8a215061b33";
    public $appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    public $expire = 24 * 3600;

    public function run()
    {
        $this->test_buildToken();
    }

    public function test_buildToken()
    {
        $token = FpaTokenBuilder::buildToken($this->appId, $this->appCertificate);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual(ServiceFpa::SERVICE_TYPE, $accessToken->services[ServiceFpa::SERVICE_TYPE]->type);
        Util::assertEqual(0, $accessToken->services[ServiceFpa::SERVICE_TYPE]->privileges[ServiceFpa::PRIVILEGE_LOGIN]);
    }
}

$fpaTokenBuilderTest = new FpaTokenBuilderTest();
$fpaTokenBuilderTest->run();