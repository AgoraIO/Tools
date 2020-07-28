<?php

require_once "../src/AccessToken2.php";

class AccessToken2Test
{
    public $appId = "970CA35de60c44645bbae8a215061b33";
    public $appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    public $channelName = "7d72365eb983485397e3e3f9d460bdda";
    public $expire = 600;
    public $issueTs = 1111111;
    public $salt = 1;
    public $uid = 2882341273;
    public $uidStr = "2882341273";
    public $userId = "test_user";

    public function run()
    {
        $this->test_build_ServiceRtc();
        $this->test_build_ServiceRtc_uid_0();
        $this->test_build_ServiceRtc_account();
        $this->test_build_multi_service();
        $this->test_parse_TokenRtc();
        $this->test_parse_TokenRtc_Rtm_MultiService();
        $this->test_parse_TokenRtm();
    }

    public function test_build_ServiceRtc()
    {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;

        $serviceRtc = new ServiceRtc($this->channelName, $this->uid);
        $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_JOIN_CHANNEL, $this->expire);

        $accessToken->addService($serviceRtc);
        $token = $accessToken->build();
        Util::assertEqual("007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj", $token);
    }

    public function test_build_ServiceRtc_uid_0()
    {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;

        $serviceRtc = new ServiceRtc($this->channelName, "");
        $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_JOIN_CHANNEL, $this->expire);

        $accessToken->addService($serviceRtc);
        $token = $accessToken->build();
        Util::assertEqual("007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo=", $token);
    }

    public function test_build_ServiceRtc_account()
    {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;

        $serviceRtc = new ServiceRtc($this->channelName, $this->uidStr);
        $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_JOIN_CHANNEL, $this->expire);

        $accessToken->addService($serviceRtc);
        $token = $accessToken->build();
        Util::assertEqual("007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj", $token);
    }

    public function test_build_multi_service()
    {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;

        $serviceRtc = new ServiceRtc($this->channelName, $this->uidStr);
        $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_JOIN_CHANNEL, $this->expire);
        $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM, $this->expire);
        $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM, $this->expire);
        $serviceRtc->addPrivilege($serviceRtc::PRIVILEGE_PUBLISH_DATA_STREAM, $this->expire);
        $accessToken->addService($serviceRtc);

        $serviceRtm = new ServiceRtm($this->userId);
        $serviceRtm->addPrivilege($serviceRtm::PRIVILEGE_JOIN_LOGIN, $this->expire);
        $accessToken->addService($serviceRtm);

        $token = $accessToken->build();
        Util::assertEqual("007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4", $token);
    }

    public function test_parse_TokenRtc()
    {
        $accessToken = new AccessToken2();
        $res = $accessToken->parse("007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj");
        Util::assertEqual(true, $res);
        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->issueTs, $accessToken->issueTs);
        Util::assertEqual($this->salt, $accessToken->salt);
        Util::assertEqual(1, count($accessToken->services));
        Util::assertEqual($this->channelName, $accessToken->services[ServiceRtc::SERVICE_TYPE]->channelName);
        Util::assertEqual($this->uidStr, $accessToken->services[ServiceRtc::SERVICE_TYPE]->uid);
        Util::assertEqual(ServiceRtc::SERVICE_TYPE, $accessToken->services[ServiceRtc::SERVICE_TYPE]->type);
        Util::assertEqual($this->expire, $accessToken->services[ServiceRtc::SERVICE_TYPE]->privileges[ServiceRtc::PRIVILEGE_JOIN_CHANNEL]);
        Util::assertEqual(0, $accessToken->services[ServiceRtc::SERVICE_TYPE]->privileges[ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]);
        Util::assertEqual(0, $accessToken->services[ServiceRtc::SERVICE_TYPE]->privileges[ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]);
        Util::assertEqual(0, $accessToken->services[ServiceRtc::SERVICE_TYPE]->privileges[ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]);
    }

    public function test_parse_TokenRtc_Rtm_MultiService()
    {
        $accessToken = new AccessToken2();
        $res = $accessToken->parse("007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4");
        Util::assertEqual(true, $res);
        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->issueTs, $accessToken->issueTs);
        Util::assertEqual($this->salt, $accessToken->salt);
        Util::assertEqual(2, count($accessToken->services));
        Util::assertEqual($this->channelName, $accessToken->services[ServiceRtc::SERVICE_TYPE]->channelName);
        Util::assertEqual($this->uidStr, $accessToken->services[ServiceRtc::SERVICE_TYPE]->uid);
        Util::assertEqual(ServiceRtc::SERVICE_TYPE, $accessToken->services[ServiceRtc::SERVICE_TYPE]->type);
        Util::assertEqual($this->userId, $accessToken->services[ServiceRtm::SERVICE_TYPE]->userId);
        Util::assertEqual($this->expire, $accessToken->services[ServiceRtc::SERVICE_TYPE]->privileges[ServiceRtc::PRIVILEGE_JOIN_CHANNEL]);
        Util::assertEqual($this->expire, $accessToken->services[ServiceRtc::SERVICE_TYPE]->privileges[ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]);
        Util::assertEqual($this->expire, $accessToken->services[ServiceRtc::SERVICE_TYPE]->privileges[ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]);
        Util::assertEqual($this->expire, $accessToken->services[ServiceRtc::SERVICE_TYPE]->privileges[ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]);
        Util::assertEqual($this->expire, $accessToken->services[ServiceRtm::SERVICE_TYPE]->privileges[ServiceRtm::PRIVILEGE_JOIN_LOGIN]);
    }

    public function test_parse_TokenRtm()
    {
        $accessToken = new AccessToken2();
        $res = $accessToken->parse("007eJxSYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJgZGBkYwn5OhJLW4JL60OLUIEAAA//9ZVh6A");
        Util::assertEqual(true, $res);
        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->issueTs, $accessToken->issueTs);
        Util::assertEqual($this->salt, $accessToken->salt);
        Util::assertEqual(1, count($accessToken->services));
        Util::assertEqual(ServiceRtm::SERVICE_TYPE, $accessToken->services[ServiceRtm::SERVICE_TYPE]->type);
        Util::assertEqual($this->expire, $accessToken->services[ServiceRtm::SERVICE_TYPE]->privileges[ServiceRtm::PRIVILEGE_JOIN_LOGIN]);
    }
}

$accessToken2Test = new AccessToken2Test();
$accessToken2Test->run();