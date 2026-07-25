<?php

require_once "../src/AccessToken2.php";

class UnknownService extends Service
{
    /**
     * Create a service type that the parser does not recognize.
     */
    public function __construct($serviceType = 999)
    {
        parent::__construct($serviceType);
    }
}

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
    public $chatUserId = "2882341273";

    /**
     * Run all AccessToken2 test cases.
     */
    public function run()
    {
        $this->test_build_rejects_empty_services();
        $this->test_build_ServiceRtc();
        $this->test_build_ServiceRtc_uid_0();
        $this->test_build_ServiceRtc_account();
        $this->test_build_ServiceChat_user();
        $this->test_build_ServiceChat_app();
        $this->test_build_multi_service();
        $this->test_build_parse_repeated_service_type();
        $this->test_parse_extended_services_from_cpp();
        $this->test_extended_service_numeric_uid_conversion();
        $this->test_parse_unknown_service_type();
        $this->test_parse_stops_at_unknown_service_type();
        $this->test_parse_old_token_and_clear_previous_services();
        $this->test_verify_signature_preconditions();
        $this->test_parse_TokenRtc();
        $this->test_parse_TokenRtc_Rtm_Chat_MultiService();
        $this->test_parse_TokenRtm();
        $this->test_parse_TokenChat_user();
        $this->test_parse_TokenChat_app();
    }

    /**
     * Verify token generation rejects an empty service list.
     */
    public function test_build_rejects_empty_services()
    {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        Util::assertEqual("", $accessToken->build());
    }

    /**
     * Verify deterministic RTC token generation with a numeric user ID.
     */
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

    /**
     * Verify deterministic RTC token generation with an empty user ID.
     */
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

    /**
     * Verify deterministic RTC token generation with a string user account.
     */
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

    /**
     * Verify deterministic Chat user token generation.
     */
    public function test_build_ServiceChat_user() {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;

        $serviceChat = new ServiceChat($this->chatUserId);
        $serviceChat->addPrivilege($serviceChat::PRIVILEGE_USER, $this->expire);

        $accessToken->addService($serviceChat);
        $token = $accessToken->build();
        Util::assertEqual("007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg=", $token);
    }

    /**
     * Verify deterministic Chat application token generation.
     */
    public function test_build_ServiceChat_app() {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;

        $serviceChat = new ServiceChat();
        $serviceChat->addPrivilege($serviceChat::PRIVILEGE_APP, $this->expire);

        $accessToken->addService($serviceChat);
        $token = $accessToken->build();
        Util::assertEqual("007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr", $token);
    }

    /**
     * Verify deterministic token generation with distinct service types.
     */
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
        $serviceRtm->addPrivilege($serviceRtm::PRIVILEGE_LOGIN, $this->expire);
        $accessToken->addService($serviceRtm);

        $serviceChat = new ServiceChat($this->chatUserId);
        $serviceChat->addPrivilege($serviceChat::PRIVILEGE_USER, $this->expire);
        $accessToken->addService($serviceChat);

        $token = $accessToken->build();
        Util::assertEqual("007eJxTYPg19dsX8xO2Nys/bpSeoH/0j9CvSs1JWib9291PKC53l85UYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyMDAwAwkWYAYxGcCk8xgkgVMKjCYp5gbGZuZpiZZWhibWJgaW5qnGqcap1mmmJgZJKWkJHIxGFlYGBmbGBqZGzMBzYGYxMlQklpcEl9anFrEChdEVgoAw6ct/Q==", $token);
    }

    /**
     * Preserve repeated service types and their insertion order after parsing.
     */
    public function test_build_parse_repeated_service_type()
    {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;

        $serviceRtm = new ServiceRtm($this->userId);
        $serviceRtm->addPrivilege(ServiceRtm::PRIVILEGE_LOGIN, $this->expire + 50);
        $accessToken->addService($serviceRtm);

        $serviceRtc = new ServiceRtc($this->channelName, $this->uidStr);
        $serviceRtc->addPrivilege(ServiceRtc::PRIVILEGE_JOIN_CHANNEL, $this->expire);
        $accessToken->addService($serviceRtc);

        $streamRtc = new ServiceRtc("stream-channel", "stream-user");
        $streamRtc->addPrivilege(ServiceRtc::PRIVILEGE_JOIN_CHANNEL, $this->expire + 100);
        $streamRtc->addPrivilege(ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM, $this->expire + 100);
        $accessToken->addService($streamRtc);

        $token = $accessToken->build();
        Util::assertEqual(3, count($accessToken->services));
        Util::assertEqual(ServiceRtm::SERVICE_TYPE, $accessToken->services[0]->getServiceType());
        Util::assertEqual($this->channelName, $accessToken->getServices(ServiceRtc::SERVICE_TYPE)[0]->channelName);
        Util::assertEqual("stream-channel", $accessToken->getServices(ServiceRtc::SERVICE_TYPE)[1]->channelName);

        $parser = new AccessToken2();
        Util::assertEqual(true, $parser->parse($token));
        $rtcServices = $parser->getServices(ServiceRtc::SERVICE_TYPE);
        Util::assertEqual(2, count($rtcServices));
        Util::assertEqual($this->channelName, $rtcServices[0]->channelName);
        Util::assertEqual("stream-channel", $rtcServices[1]->channelName);
        Util::assertEqual($this->expire + 100, $rtcServices[1]->privileges[ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]);
        Util::assertEqual(1, count($parser->getServices(ServiceRtm::SERVICE_TYPE)));
        Util::assertEqual(0, count($parser->getServices(ServiceChat::SERVICE_TYPE)));
        Util::assertEqual(true, $parser->verifySignature($this->appCertificate));
        Util::assertEqual(false, $parser->verifySignature("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"));
    }

    /**
     * Parse and verify C++ Streaming, FCDN, and RTM2 services.
     */
    public function test_parse_extended_services_from_cpp()
    {
        $token = "007eJxTYPj86Lzdz79M25wNn/lMfvu+TkfmdpiviKvChm8ZV3SWndytwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs7P5FgCGCiYGBkYGBgRkImYAsEJ8JTCowmKeYGxmbmaYmWVoYm1iYGluapxqnGqdZppiYGSSlpCRyMRhZWBgZmxgamRuzUaSbA6gXopuToSS1uCS+tDi1iJkB4jQmoGBuanFxYnqqbiKCmcTIAIEcDMUlRamJubqJLGD1jAxsDCD9uokAO/VDvQ==";
        $parser = new AccessToken2();

        Util::assertEqual(true, $parser->parse($token));
        Util::assertEqual(true, $parser->verifySignature($this->appCertificate));

        $streaming = $parser->getServices(ServiceStreaming::SERVICE_TYPE)[0];
        Util::assertEqual($this->channelName, $streaming->channelName);
        Util::assertEqual($this->uidStr, $streaming->account);
        Util::assertEqual($this->expire, $streaming->privileges[ServiceStreaming::PRIVILEGE_PUBLISH_MIX_STREAM]);
        Util::assertEqual($this->expire, $streaming->privileges[ServiceStreaming::PRIVILEGE_PUBLISH_RAW_STREAM]);

        $fcdn = $parser->getServices(ServiceFCdn::SERVICE_TYPE)[0];
        Util::assertEqual($this->channelName, $fcdn->channelName);
        Util::assertEqual($this->uidStr, $fcdn->account);
        Util::assertEqual($this->expire, $fcdn->privileges[ServiceFCdn::PRIVILEGE_PUBLISH]);
        Util::assertEqual($this->expire, $fcdn->privileges[ServiceFCdn::PRIVILEGE_PLAY]);

        $rtm2 = $parser->getServices(ServiceRtm2::SERVICE_TYPE)[0];
        Util::assertEqual($this->userId, $rtm2->userId);
        Util::assertEqual(
            json_encode([0 => [0 => ["message-a", "message-b"]], 1 => [1 => ["stream-a"]], 4 => [0 => ["user-a"]]]),
            json_encode($rtm2->permissions->details)
        );
    }

    /**
     * Verify deterministic Streaming and FCDN generation and UID conversion against C++.
     */
    public function test_extended_service_numeric_uid_conversion()
    {
        $token = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $token->issueTs = $this->issueTs;
        $token->salt = $this->salt;
        $streamingServices = [
            new ServiceStreaming($this->channelName, $this->uid),
            new ServiceStreaming($this->channelName, 0),
            new ServiceStreaming($this->channelName, "stream-account"),
        ];
        $streamingServices[0]->addPrivilege(ServiceStreaming::PRIVILEGE_PUBLISH_MIX_STREAM, $this->expire);
        $streamingServices[1]->addPrivilege(ServiceStreaming::PRIVILEGE_PUBLISH_RAW_STREAM, $this->expire);
        $streamingServices[2]->addPrivilege(ServiceStreaming::PRIVILEGE_PUBLISH_MIX_STREAM, $this->expire);
        $streamingServices[2]->addPrivilege(ServiceStreaming::PRIVILEGE_PUBLISH_RAW_STREAM, $this->expire);
        $fcdnServices = [
            new ServiceFCdn($this->channelName, $this->uid),
            new ServiceFCdn($this->channelName, 0),
            new ServiceFCdn($this->channelName, "fcdn-account"),
        ];
        $fcdnServices[0]->addPrivilege(ServiceFCdn::PRIVILEGE_PUBLISH, $this->expire);
        $fcdnServices[1]->addPrivilege(ServiceFCdn::PRIVILEGE_PLAY, $this->expire);
        $fcdnServices[2]->addPrivilege(ServiceFCdn::PRIVILEGE_PUBLISH, $this->expire);
        $fcdnServices[2]->addPrivilege(ServiceFCdn::PRIVILEGE_PLAY, $this->expire);
        foreach (array_merge($streamingServices, $fcdnServices) as $service) {
            $token->addService($service);
        }

        $encoded = $token->build();
        Util::assertEqual(
            "007eJxTYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwA2lGMF+BwTzF3MjYzDQ1ydLC2MTC1NjSPNU41TjNMsXEzCApJSWRi8HIwsLI2MTQyNwYpI+JSH0MQFuYoLYQq4ePobikKDUxVzcxOTm/NK+EjUx3spHkTjaS3cnDkJackgdzJQBJb19X",
            $encoded
        );
        $parsed = new AccessToken2();
        Util::assertEqual(true, $parsed->parse($encoded));
        Util::assertEqual(
            [$this->uidStr, "", "stream-account"],
            array_map(function ($service) { return $service->account; }, $parsed->getServices(ServiceStreaming::SERVICE_TYPE))
        );
        Util::assertEqual(
            [$this->uidStr, "", "fcdn-account"],
            array_map(function ($service) { return $service->account; }, $parsed->getServices(ServiceFCdn::SERVICE_TYPE))
        );
    }

    /**
     * Keep known services parsed before an unknown service type.
     */
    public function test_parse_unknown_service_type()
    {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;

        $serviceRtc = new ServiceRtc($this->channelName, $this->uidStr);
        $serviceRtc->addPrivilege(ServiceRtc::PRIVILEGE_JOIN_CHANNEL, $this->expire);
        $accessToken->addService($serviceRtc);

        $unknown = new UnknownService();
        $unknown->addPrivilege(1, $this->expire);
        $accessToken->addService($unknown);

        $parser = new AccessToken2();
        Util::assertEqual(true, $parser->parse($accessToken->build()));
        Util::assertEqual(1, count($parser->getServices(ServiceRtc::SERVICE_TYPE)));
        Util::assertEqual(0, count($parser->getServices(999)));
        Util::assertEqual(true, $parser->verifySignature($this->appCertificate));
    }

    /**
     * Stop before known services that follow an unknown service payload.
     */
    public function test_parse_stops_at_unknown_service_type()
    {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;

        $serviceRtc = new ServiceRtc($this->channelName, $this->uidStr);
        $serviceRtc->addPrivilege(ServiceRtc::PRIVILEGE_JOIN_CHANNEL, $this->expire);
        $accessToken->addService($serviceRtc);

        $unknown = new UnknownService(0);
        $unknown->addPrivilege(1, $this->expire);
        $accessToken->addService($unknown);

        $parser = new AccessToken2();
        Util::assertEqual(true, $parser->parse($accessToken->build()));
        Util::assertEqual(0, count($parser->getServices(ServiceRtc::SERVICE_TYPE)));
        Util::assertEqual(true, $parser->verifySignature($this->appCertificate));
    }

    /**
     * Parse an old token and replace services from an earlier parse.
     */
    public function test_parse_old_token_and_clear_previous_services()
    {
        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;

        $serviceRtm = new ServiceRtm($this->userId);
        $serviceRtm->addPrivilege(ServiceRtm::PRIVILEGE_LOGIN, $this->expire);
        $accessToken->addService($serviceRtm);

        $parser = new AccessToken2();
        Util::assertEqual(true, $parser->parse($accessToken->build()));
        Util::assertEqual(1, count($parser->getServices(ServiceRtm::SERVICE_TYPE)));

        $oldToken = "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj";
        Util::assertEqual(true, $parser->parse($oldToken));
        Util::assertEqual(1, count($parser->services));
        Util::assertEqual(1, count($parser->getServices(ServiceRtc::SERVICE_TYPE)));
        Util::assertEqual(0, count($parser->getServices(ServiceRtm::SERVICE_TYPE)));
        Util::assertEqual(true, $parser->verifySignature($this->appCertificate));
    }

    /**
     * Reject signature verification before parsing or with invalid certificates.
     */
    public function test_verify_signature_preconditions()
    {
        $parser = new AccessToken2();
        Util::assertEqual(false, $parser->verifySignature($this->appCertificate));

        $accessToken = new AccessToken2($this->appId, $this->appCertificate, $this->expire);
        $accessToken->issueTs = $this->issueTs;
        $accessToken->salt = $this->salt;
        $serviceRtc = new ServiceRtc($this->channelName, $this->uidStr);
        $serviceRtc->addPrivilege(ServiceRtc::PRIVILEGE_JOIN_CHANNEL, $this->expire);
        $accessToken->addService($serviceRtc);

        Util::assertEqual(true, $parser->parse($accessToken->build()));
        Util::assertEqual(false, $parser->verifySignature("invalid"));
        Util::assertEqual(false, $parser->verifySignature(str_repeat("z", 32)));
        Util::assertEqual(true, $parser->verifySignature($this->appCertificate));

        Util::assertEqual(false, $parser->parse("006invalid"));
        Util::assertEqual(false, $parser->verifySignature($this->appCertificate));
        Util::assertEqual(0, count($parser->services));
    }

    /**
     * Parse a legacy RTC token and verify its fields and privileges.
     */
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
        $serviceRtc = $accessToken->getServices(ServiceRtc::SERVICE_TYPE)[0];
        Util::assertEqual($this->channelName, $serviceRtc->channelName);
        Util::assertEqual($this->uidStr, $serviceRtc->uid);
        Util::assertEqual(ServiceRtc::SERVICE_TYPE, $serviceRtc->type);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_JOIN_CHANNEL]);
        Util::assertEqual(0, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM] ?? 0);
        Util::assertEqual(0, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM] ?? 0);
        Util::assertEqual(0, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM] ?? 0);
    }

    /**
     * Parse a token containing RTC, RTM, and Chat services.
     */
    public function test_parse_TokenRtc_Rtm_Chat_MultiService()
    {
        $accessToken = new AccessToken2();
        $res = $accessToken->parse("007eJxTYPg19dsX8xO2Nys/bpSeoH/0j9CvSs1JWib9291PKC53l85UYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyMDAwAwkWYAYxGcCk8xgkgVMKjCYp5gbGZuZpiZZWhibWJgaW5qnGqcap1mmmJgZJKWkJHIxGFlYGBmbGBqZGzMBzYGYxMlQklpcEl9anFrEChdEVgoAw6ct/Q==");
        Util::assertEqual(true, $res);
        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->issueTs, $accessToken->issueTs);
        Util::assertEqual($this->salt, $accessToken->salt);
        Util::assertEqual(3, count($accessToken->services));
        $serviceRtc = $accessToken->getServices(ServiceRtc::SERVICE_TYPE)[0];
        $serviceRtm = $accessToken->getServices(ServiceRtm::SERVICE_TYPE)[0];
        $serviceChat = $accessToken->getServices(ServiceChat::SERVICE_TYPE)[0];
        Util::assertEqual($this->channelName, $serviceRtc->channelName);
        Util::assertEqual($this->uidStr, $serviceRtc->uid);
        Util::assertEqual(ServiceRtc::SERVICE_TYPE, $serviceRtc->type);
        Util::assertEqual($this->userId, $serviceRtm->userId);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_JOIN_CHANNEL]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_AUDIO_STREAM]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_VIDEO_STREAM]);
        Util::assertEqual($this->expire, $serviceRtc->privileges[ServiceRtc::PRIVILEGE_PUBLISH_DATA_STREAM]);
        Util::assertEqual($this->expire, $serviceRtm->privileges[ServiceRtm::PRIVILEGE_LOGIN]);
        // CHAT
        Util::assertEqual(ServiceChat::SERVICE_TYPE, $serviceChat->type);
        Util::assertEqual($this->chatUserId, $serviceChat->userId);
        Util::assertEqual($this->expire, $serviceChat->privileges[ServiceChat::PRIVILEGE_USER]);
        
    }

    /**
     * Parse a legacy RTM token and verify its login privilege.
     */
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
        $serviceRtm = $accessToken->getServices(ServiceRtm::SERVICE_TYPE)[0];
        Util::assertEqual(ServiceRtm::SERVICE_TYPE, $serviceRtm->type);
        Util::assertEqual($this->expire, $serviceRtm->privileges[ServiceRtm::PRIVILEGE_LOGIN]);
    }

    /**
     * Parse a Chat user token and verify its user privilege.
     */
    public function test_parse_TokenChat_user()
    {
        $accessToken = new AccessToken2();
        $res = $accessToken->parse("007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg=");
        Util::assertEqual(true, $res);
        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->issueTs, $accessToken->issueTs);
        Util::assertEqual($this->salt, $accessToken->salt);
        Util::assertEqual(1, count($accessToken->services));
        $serviceChat = $accessToken->getServices(ServiceChat::SERVICE_TYPE)[0];
        Util::assertEqual(ServiceChat::SERVICE_TYPE, $serviceChat->type);
        Util::assertEqual($this->chatUserId, $serviceChat->userId);
        Util::assertEqual($this->expire, $serviceChat->privileges[ServiceChat::PRIVILEGE_USER]);
    }

    /**
     * Parse a Chat application token and verify its application privilege.
     */
    public function test_parse_TokenChat_app()
    {
        $accessToken = new AccessToken2();
        $res = $accessToken->parse("007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr");
        Util::assertEqual(true, $res);
        Util::assertEqual($this->appId, $accessToken->appId);
        Util::assertEqual($this->expire, $accessToken->expire);
        Util::assertEqual($this->issueTs, $accessToken->issueTs);
        Util::assertEqual($this->salt, $accessToken->salt);
        Util::assertEqual(1, count($accessToken->services));
        $serviceChat = $accessToken->getServices(ServiceChat::SERVICE_TYPE)[0];
        Util::assertEqual(ServiceChat::SERVICE_TYPE, $serviceChat->type);
        Util::assertEqual($this->expire, $serviceChat->privileges[ServiceChat::PRIVILEGE_APP]);
    }
}

$accessToken2Test = new AccessToken2Test();
$accessToken2Test->run();
