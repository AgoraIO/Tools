<?php

require_once "../src/AccessToken2.php";
require_once "../src/RtcTokenBuilder2.php";

class RtcTokenBuilder2Test
{
    public $account = "2882341273";
    public $appId = "970CA35de60c44645bbae8a215061b33";
    public $appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    public $channelName = "7d72365eb983485397e3e3f9d460bdda";
    public $expire = 600;
    public $uid = 2882341273;
    public $uidStr = "2882341273";

    /**
     * Run all RTC token builder test cases.
     */
    public function run()
    {
        $this->test_buildTokenWithUid_ROLE_PUBLISHER();
        $this->test_buildTokenWithUserAccount_ROLE_PUBLISHER();
        $this->test_buildTokenWithUserAccount_ROLE_SUBSCRIBER();
        $this->test_buildTokenWithUidAndPrivilege();
        $this->test_buildTokenWithUserAccountAndPrivilege();
    }

    /**
     * Verify publisher token generation with a numeric user ID.
     */
    public function test_buildTokenWithUid_ROLE_PUBLISHER()
    {
        $token = RtcTokenBuilder2::buildTokenWithUid($this->appId, $this->appCertificate, $this->channelName, $this->uid, RtcTokenBuilder2::ROLE_PUBLISHER, $this->expire, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);
        $serviceRtc = $accessToken->getServices(ServiceRtc::SERVICE_TYPE)[0];

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->channelName, $serviceRtc->channelName);
        Util::assertEqual($this->uid, $serviceRtc->uid);
        Util::assertEqual(ServiceRtc::SERVICE_TYPE, $serviceRtc->type);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_JOIN_CHANNEL]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]);
    }

    /**
     * Verify publisher token generation with a string user account.
     */
    public function test_buildTokenWithUserAccount_ROLE_PUBLISHER()
    {
        $token = RtcTokenBuilder2::buildTokenWithUserAccount($this->appId, $this->appCertificate, $this->channelName, $this->account, RtcTokenBuilder2::ROLE_PUBLISHER, $this->expire, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);
        $serviceRtc = $accessToken->getServices(ServiceRtc::SERVICE_TYPE)[0];

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->channelName, $serviceRtc->channelName);
        Util::assertEqual($this->account, $serviceRtc->uid);
        Util::assertEqual(ServiceRtc::SERVICE_TYPE, $serviceRtc->type);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_JOIN_CHANNEL]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]);
    }

    /**
     * Verify subscriber token generation with a string user account.
     */
    public function test_buildTokenWithUserAccount_ROLE_SUBSCRIBER()
    {
        $token = RtcTokenBuilder2::buildTokenWithUserAccount($this->appId, $this->appCertificate, $this->channelName, $this->account, RtcTokenBuilder2::ROLE_SUBSCRIBER, $this->expire, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);
        $serviceRtc = $accessToken->getServices(ServiceRtc::SERVICE_TYPE)[0];

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->channelName, $serviceRtc->channelName);
        Util::assertEqual($this->account, $serviceRtc->uid);
        Util::assertEqual(ServiceRtc::SERVICE_TYPE, $serviceRtc->type);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_JOIN_CHANNEL]);
        Util::assertEqual(0, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM] ?? 0);
        Util::assertEqual(0, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM] ?? 0);
        Util::assertEqual(0, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM] ?? 0);
    }

    /**
     * Verify numeric user token generation with explicit privilege expirations.
     */
    public function test_buildTokenWithUidAndPrivilege()
    {
        $token = RtcTokenBuilder2::buildTokenWithUidAndPrivilege($this->appId, $this->appCertificate, $this->channelName, $this->uid,
            $this->expire, $this->expire, $this->expire, $this->expire, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);
        $serviceRtc = $accessToken->getServices(ServiceRtc::SERVICE_TYPE)[0];

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->channelName, $serviceRtc->channelName);
        Util::assertEqual($this->uid, $serviceRtc->uid);
        Util::assertEqual(ServiceRtc::SERVICE_TYPE, $serviceRtc->type);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_JOIN_CHANNEL]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]);
    }

    /**
     * Verify account token generation with explicit privilege expirations.
     */
    public function test_buildTokenWithUserAccountAndPrivilege()
    {
        $token = RtcTokenBuilder2::buildTokenWithUserAccountAndPrivilege($this->appId, $this->appCertificate, $this->channelName, $this->account,
            $this->expire, $this->expire, $this->expire, $this->expire, $this->expire);
        $accessToken = new AccessToken2();
        $accessToken->parse($token);
        $serviceRtc = $accessToken->getServices(ServiceRtc::SERVICE_TYPE)[0];

        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->channelName, $serviceRtc->channelName);
        Util::assertEqual($this->account, $serviceRtc->uid);
        Util::assertEqual(ServiceRtc::SERVICE_TYPE, $serviceRtc->type);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_JOIN_CHANNEL]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]);
    }
}

$rtcTokenBuilder2Test = new RtcTokenBuilder2Test();
$rtcTokenBuilder2Test->run();
