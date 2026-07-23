<?php

require_once "../src/AccessToken2.php";
require_once "../src/ApaasTokenBuilder.php";

class ApaasTokenBuilderTest
{
    public $appId = "970CA35de60c44645bbae8a215061b33";
    public $appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    public $expire = 600;
    public $roomUuid = "123";
    public $userUuid = "2882341273";
    public $role = 1;

    /**
     * Run all APaaS token builder test cases.
     */
    public function run()
    {
        $this->test_buildRoomUserToken();
        $this->test_buildUserToken();
        $this->test_buildAppToken();
    }

    /**
     * Verify APaaS room user token generation and parsing.
     */
    public function test_buildRoomUserToken()
    {
        $token = ApaasTokenBuilder::buildRoomUserToken($this->appId, $this->appCertificate, $this->roomUuid, $this->userUuid, $this->role, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);
        $serviceApaas = $accessToken->getServices(ServiceApaas::SERVICE_TYPE)[0];

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->roomUuid, $serviceApaas->roomUuid);
        Util::assertEqual($this->userUuid, $serviceApaas->userUuid);
        Util::assertEqual($this->role, $serviceApaas->role);
        Util::assertEqual($this->expire, $serviceApaas->privileges[ServiceApaas::PRIVILEGE_ROOM_USER]);
    }

    /**
     * Verify APaaS user token generation and parsing.
     */
    public function test_buildUserToken()
    {
        $token = ApaasTokenBuilder::buildUserToken($this->appId, $this->appCertificate, $this->userUuid, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);
        $serviceApaas = $accessToken->getServices(ServiceApaas::SERVICE_TYPE)[0];

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->userUuid, $serviceApaas->userUuid);
        Util::assertEqual("", $serviceApaas->roomUuid);
        Util::assertEqual(-1, $serviceApaas->role);
        Util::assertEqual($this->expire, $serviceApaas->privileges[ServiceApaas::PRIVILEGE_USER]);
    }

    /**
     * Verify APaaS application token generation and parsing.
     */
    public function test_buildAppToken()
    {
        $token = ApaasTokenBuilder::buildAppToken($this->appId, $this->appCertificate, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);
        $serviceApaas = $accessToken->getServices(ServiceApaas::SERVICE_TYPE)[0];

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->expire, $serviceApaas->privileges[ServiceApaas::PRIVILEGE_APP]);

        Util::assertEqual("", $serviceApaas->roomUuid);
        Util::assertEqual("", $serviceApaas->userUuid);
        Util::assertEqual(-1, $serviceApaas->role);
    }
}

$apaasTokenBuilderTest = new ApaasTokenBuilderTest();
$apaasTokenBuilderTest->run();
