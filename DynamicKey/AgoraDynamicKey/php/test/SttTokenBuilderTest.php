<?php

require_once "../src/AccessToken2.php";
require_once "../src/SttTokenBuilder.php";

class SttTokenBuilderTest
{
    public $appId = "970CA35de60c44645bbae8a215061b33";
    public $appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    public $channelName = "7d72365eb983485397e3e3f9d460bdda";
    public $rtcAccount = "2882341273";
    public $rtmUserId = "2882341273";
    public $rtcTokenExpire = 600;
    public $joinChannelPrivilegeExpire = 600;
    public $pubAudioPrivilegeExpire = 600;
    public $pubVideoPrivilegeExpire = 600;
    public $pubDataStreamPrivilegeExpire = 600;
    public $rtmTokenExpire = 600;

    public function run()
    {
        $this->test_buildToken_ROLE_PUBLISHER();
        $this->test_buildToken_ROLE_SUBSCRIBER();
    }

    public function test_buildToken_ROLE_PUBLISHER()
    {
        $token = SttTokenBuilder::buildToken(
            $this->appId, $this->appCertificate, $this->channelName, $this->rtcAccount,
            RtcTokenBuilder2::ROLE_PUBLISHER, $this->rtcTokenExpire, $this->joinChannelPrivilegeExpire,
            $this->pubAudioPrivilegeExpire, $this->pubVideoPrivilegeExpire, $this->pubDataStreamPrivilegeExpire,
            $this->rtmUserId, $this->rtmTokenExpire
        );
        $parser = new AccessToken2();
        $parser->parse($token);

        Util::assertEqual($this->appId, $parser->appId);
        Util::assertEqual($this->rtcTokenExpire, $parser->expire);
        Util::assertEqual($this->rtcAccount, $parser->getServices(ServiceRtc::SERVICE_TYPE)[0]->uid);
        Util::assertEqual($this->rtmUserId, $parser->getServices(ServiceRtm::SERVICE_TYPE)[0]->userId);
        Util::assertEqual(0, count($parser->getServices(ServiceStt::SERVICE_TYPE)[0]->privileges));
    }

    public function test_buildToken_ROLE_SUBSCRIBER()
    {
        $token = SttTokenBuilder::buildToken(
            $this->appId, $this->appCertificate, $this->channelName, $this->rtcAccount,
            RtcTokenBuilder2::ROLE_SUBSCRIBER, $this->rtcTokenExpire, $this->joinChannelPrivilegeExpire,
            $this->pubAudioPrivilegeExpire, $this->pubVideoPrivilegeExpire, $this->pubDataStreamPrivilegeExpire,
            $this->rtmUserId, $this->rtmTokenExpire
        );
        $parser = new AccessToken2();
        $parser->parse($token);

        Util::assertEqual(
            json_encode([ServiceRtc::PRIVILEGE_JOIN_CHANNEL => $this->joinChannelPrivilegeExpire]),
            json_encode($parser->getServices(ServiceRtc::SERVICE_TYPE)[0]->privileges)
        );
    }
}

$test = new SttTokenBuilderTest();
$test->run();
