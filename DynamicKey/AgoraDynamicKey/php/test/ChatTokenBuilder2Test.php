<?php

require_once "../src/AccessToken2.php";
require_once "../src/ChatTokenBuilder2.php";

class ChatTokenBuilder2Test
{
    public $appId = "970CA35de60c44645bbae8a215061b33";
    public $appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    public $expire = 600;
    public $userId = "2882341273";

    public function run()
    {
        $this->test_buildUserToken();
        $this->test_buildAppToken();
    }

    public function test_buildUserToken()
    {
        $token = ChatTokenBuilder2::buildUserToken($this->appId, $this->appCertificate, $this->userId, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual(ServiceChat::SERVICE_TYPE, $accessToken->services[ServiceChat::SERVICE_TYPE]->type);
        Util::assertEqual($this->userId, $accessToken->services[ServiceChat::SERVICE_TYPE]->userId);
        Util::assertEqual($this->expire, $accessToken->services[ServiceChat::SERVICE_TYPE]->privileges[ServiceChat::PRIVILEGE_USER]);
    }

    public function test_buildAppToken()
    {
        $token = ChatTokenBuilder2::buildAppToken($this->appId, $this->appCertificate, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual(ServiceChat::SERVICE_TYPE, $accessToken->services[ServiceChat::SERVICE_TYPE]->type);
        Util::assertEqual($this->expire, $accessToken->services[ServiceChat::SERVICE_TYPE]->privileges[ServiceChat::PRIVILEGE_APP]);
    }
}

$chatTokenBuilder2Test = new ChatTokenBuilder2Test();
$chatTokenBuilder2Test->run();