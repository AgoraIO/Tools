package io.agora.media;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.junit.Test;

/**
 * Tests Token007 generation, parsing, compatibility, and signature verification.
 */
public class AccessToken2Test {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private String channelName = "7d72365eb983485397e3e3f9d460bdda";
    private int expire = 600;
    private int issueTs = 1111111;
    private int salt = 1;
    private String uid = "2882341273";
    private String userId = "test_user";

    /**
     * Verifies token generation rejects an empty service list.
     */
    @Test
    public void buildRejectsEmptyServices() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        assertEquals(appCertificate, accessToken.appCert);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);

        assertEquals("", accessToken.build());
    }

    /**
     * Verifies deterministic RTC token generation.
     */
    @Test
    public void build_ServiceRtc() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        accessToken.addService(serviceRtc);

        assertEquals(channelName, serviceRtc.channelName);
        assertEquals(uid, serviceRtc.uid);

        String token = accessToken.build();
        assertEquals(
                "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj",
                token);
    }

    /**
     * Verifies deterministic RTC token generation with an empty user ID.
     */
    @Test
    public void build_ServiceRtc_uid_0() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, "");
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        accessToken.addService(serviceRtc);

        assertEquals(channelName, serviceRtc.channelName);
        assertEquals("", serviceRtc.uid);

        String token = accessToken.build();
        assertEquals(
                "007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo=",
                token);
    }

    /**
     * Verifies deterministic RTC token generation with a user account.
     */
    @Test
    public void build_ServiceRtc_account() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        accessToken.addService(serviceRtc);

        assertEquals(channelName, serviceRtc.channelName);
        assertEquals(uid, serviceRtc.uid);

        String token = accessToken.build();
        assertEquals(
                "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj",
                token);
    }

    /**
     * Verifies deterministic RTM token generation.
     */
    @Test
    public void build_ServiceRtm() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtm serviceRtm = new AccessToken2.ServiceRtm(userId);
        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire);

        accessToken.addService(serviceRtm);
        String expected = "007eJxTYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJiBmBPM5GUpSi0viS4tTiwBZVh6A";

        assertEquals(expected, accessToken.build());
    }

    /**
     * Verifies deterministic Chat user token generation.
     */
    @Test
    public void build_ServiceChat_userToken() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceChat serviceChat = new AccessToken2.ServiceChat(uid);
        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER, expire);

        accessToken.addService(serviceChat);
        String expected = "007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg=";

        assertEquals(expected, accessToken.build());
    }

    /**
     * Verifies deterministic Chat application token generation.
     */
    @Test
    public void build_ServiceChat_appToken() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceChat serviceChat = new AccessToken2.ServiceChat();
        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_APP, expire);

        accessToken.addService(serviceChat);
        String expected = "007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr";

        assertEquals(expected, accessToken.build());
    }

    /**
     * Verifies deterministic token generation with distinct service types.
     */
    @Test
    public void build_multi_service() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM, expire);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_VIDEO_STREAM, expire);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM, expire);
        accessToken.addService(serviceRtc);

        AccessToken2.ServiceRtm serviceRtm = new AccessToken2.ServiceRtm(userId);
        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire);
        accessToken.addService(serviceRtm);

        AccessToken2.ServiceChat serviceChat = new AccessToken2.ServiceChat(uid);
        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER, expire);
        accessToken.addService(serviceChat);

        assertEquals(channelName, serviceRtc.channelName);
        assertEquals(uid, serviceRtc.uid);
        assertEquals(userId, serviceRtm.userId);

        String expected = "007eJxTYPg19dsX8xO2Nys/bpSeoH/0j9CvSs1JWib9291PKC53l85UYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyMDAwAwkWYAYxGcCk8xgkgVMKjCYp5gbGZuZpiZZWhibWJgaW5qnGqcap1mmmJgZJKWkJHIxGFlYGBmbGBqZGzMBzYGYxMlQklpcEl9anFrEChdEVgoAw6ct/Q==";
        String token = accessToken.build();
        assertEquals(expected, token);
    }

    /**
     * Preserves repeated service types and their insertion order after parsing.
     */
    @Test
    public void buildParseRepeatedServiceType() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtm serviceRtm = new AccessToken2.ServiceRtm(userId);
        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire + 50);
        accessToken.addService(serviceRtm);

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        accessToken.addService(serviceRtc);

        AccessToken2.ServiceRtc streamRtc = new AccessToken2.ServiceRtc("stream-channel", "stream-user");
        streamRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire + 100);
        streamRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM, expire + 100);
        accessToken.addService(streamRtc);

        String token = accessToken.build();
        assertEquals(3, accessToken.services.size());
        assertEquals(serviceRtm, accessToken.services.get(0));
        assertEquals(2, accessToken.getServices(AccessToken2.SERVICE_TYPE_RTC).size());

        AccessToken2 parser = new AccessToken2();
        assertTrue(parser.parse(token));
        assertEquals(2, parser.getServices(AccessToken2.SERVICE_TYPE_RTC).size());
        assertEquals(channelName,
                ((AccessToken2.ServiceRtc) parser.getServices(AccessToken2.SERVICE_TYPE_RTC).get(0)).getChannelName());
        assertEquals("stream-channel",
                ((AccessToken2.ServiceRtc) parser.getServices(AccessToken2.SERVICE_TYPE_RTC).get(1)).getChannelName());
        assertEquals(expire + 100, (int) parser.getServices(AccessToken2.SERVICE_TYPE_RTC).get(1)
                .getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM.intValue));
        assertEquals(1, parser.getServices(AccessToken2.SERVICE_TYPE_RTM).size());
        assertTrue(parser.verifySignature(appCertificate));
        assertFalse(parser.verifySignature("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"));
    }

    /**
     * Parses and verifies C++ Streaming, FCDN, and RTM2 services.
     */
    @Test
    public void parseExtendedServicesFromCpp() {
        String token = "007eJxTYPj86Lzdz79M25wNn/lMfvu+TkfmdpiviKvChm8ZV3SWndytwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs7P5FgCGCiYGBkYGBgRkImYAsEJ8JTCowmKeYGxmbmaYmWVoYm1iYGluapxqnGqdZppiYGSSlpCRyMRhZWBgZmxgamRuzUaSbA6gXopuToSS1uCS+tDi1iJkB4jQmoGBuanFxYnqqbiKCmcTIAIEcDMUlRamJubqJLGD1jAxsDCD9uokAO/VDvQ==";
        AccessToken2 parser = new AccessToken2();

        assertTrue(parser.parse(token));
        assertTrue(parser.verifySignature(appCertificate));

        AccessToken2.ServiceStreaming streaming = (AccessToken2.ServiceStreaming)
                parser.getServices(AccessToken2.SERVICE_TYPE_STREAMING).get(0);
        assertEquals(channelName, streaming.channelName);
        assertEquals(uid, streaming.account);
        assertEquals(expire, (int) streaming.privileges.get(AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_MIX_STREAM.intValue));
        assertEquals(expire, (int) streaming.privileges.get(AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_RAW_STREAM.intValue));

        AccessToken2.ServiceFCdn fcdn = (AccessToken2.ServiceFCdn)
                parser.getServices(AccessToken2.SERVICE_TYPE_FCDN).get(0);
        assertEquals(channelName, fcdn.channelName);
        assertEquals(uid, fcdn.account);
        assertEquals(expire, (int) fcdn.privileges.get(AccessToken2.PrivilegeFCdn.PRIVILEGE_PUBLISH.intValue));
        assertEquals(expire, (int) fcdn.privileges.get(AccessToken2.PrivilegeFCdn.PRIVILEGE_PLAY.intValue));

        AccessToken2.ServiceRtm2 rtm2 = (AccessToken2.ServiceRtm2)
                parser.getServices(AccessToken2.SERVICE_TYPE_RTM2).get(0);
        AccessToken2.ServiceRtm2.Permissions expected = new AccessToken2.ServiceRtm2.Permissions();
        expected.add(AccessToken2.ServiceRtm2.Permissions.MESSAGE_CHANNELS,
                AccessToken2.ServiceRtm2.Permissions.READ, Arrays.asList("message-a", "message-b"));
        expected.add(AccessToken2.ServiceRtm2.Permissions.STREAM_CHANNELS,
                AccessToken2.ServiceRtm2.Permissions.WRITE, Arrays.asList("stream-a"));
        expected.add(AccessToken2.ServiceRtm2.Permissions.USERS,
                AccessToken2.ServiceRtm2.Permissions.READ, Arrays.asList("user-a"));
        assertEquals(userId, rtm2.userId);
        assertEquals(expected.details, rtm2.permissions.details);
    }

    /**
     * Verifies deterministic Streaming and FCDN generation and UID conversion against C++.
     */
    @Test
    public void extendedServiceNumericUidConversion() throws Exception {
        AccessToken2 token = new AccessToken2(appId, appCertificate, expire);
        token.issueTs = issueTs;
        token.salt = salt;
        AccessToken2.ServiceStreaming streamingUid = new AccessToken2.ServiceStreaming(channelName, 2882341273L);
        streamingUid.addPrivilegeStreaming(AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_MIX_STREAM, expire);
        token.addService(streamingUid);
        AccessToken2.ServiceStreaming streamingWildcard = new AccessToken2.ServiceStreaming(channelName, 0L);
        streamingWildcard.addPrivilegeStreaming(AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_RAW_STREAM, expire);
        token.addService(streamingWildcard);
        AccessToken2.ServiceStreaming streamingAccount = new AccessToken2.ServiceStreaming(channelName, "stream-account");
        streamingAccount.addPrivilegeStreaming(AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_MIX_STREAM, expire);
        streamingAccount.addPrivilegeStreaming(AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_RAW_STREAM, expire);
        token.addService(streamingAccount);
        AccessToken2.ServiceFCdn fcdnUid = new AccessToken2.ServiceFCdn(channelName, 2882341273L);
        fcdnUid.addPrivilegeFCdn(AccessToken2.PrivilegeFCdn.PRIVILEGE_PUBLISH, expire);
        token.addService(fcdnUid);
        AccessToken2.ServiceFCdn fcdnWildcard = new AccessToken2.ServiceFCdn(channelName, 0L);
        fcdnWildcard.addPrivilegeFCdn(AccessToken2.PrivilegeFCdn.PRIVILEGE_PLAY, expire);
        token.addService(fcdnWildcard);
        AccessToken2.ServiceFCdn fcdnAccount = new AccessToken2.ServiceFCdn(channelName, "fcdn-account");
        fcdnAccount.addPrivilegeFCdn(AccessToken2.PrivilegeFCdn.PRIVILEGE_PUBLISH, expire);
        fcdnAccount.addPrivilegeFCdn(AccessToken2.PrivilegeFCdn.PRIVILEGE_PLAY, expire);
        token.addService(fcdnAccount);

        String encoded = token.build();
        assertEquals(
                "007eJxTYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwA2lGMF+BwTzF3MjYzDQ1ydLC2MTC1NjSPNU41TjNMsXEzCApJSWRi8HIwsLI2MTQyNwYpI+JSH0MQFuYoLYQq4ePobikKDUxVzcxOTm/NK+EjUx3spHkTjaS3cnDkJackgdzJQBJb19X",
                encoded);
        AccessToken2 parsed = new AccessToken2();
        assertTrue(parsed.parse(encoded));
        assertEquals("2882341273", ((AccessToken2.ServiceStreaming)
                parsed.getServices(AccessToken2.SERVICE_TYPE_STREAMING).get(0)).account);
        assertEquals("", ((AccessToken2.ServiceStreaming)
                parsed.getServices(AccessToken2.SERVICE_TYPE_STREAMING).get(1)).account);
        assertEquals("stream-account", ((AccessToken2.ServiceStreaming)
                parsed.getServices(AccessToken2.SERVICE_TYPE_STREAMING).get(2)).account);
        assertEquals("2882341273", ((AccessToken2.ServiceFCdn)
                parsed.getServices(AccessToken2.SERVICE_TYPE_FCDN).get(0)).account);
        assertEquals("", ((AccessToken2.ServiceFCdn)
                parsed.getServices(AccessToken2.SERVICE_TYPE_FCDN).get(1)).account);
        assertEquals("fcdn-account", ((AccessToken2.ServiceFCdn)
                parsed.getServices(AccessToken2.SERVICE_TYPE_FCDN).get(2)).account);

    }

    /**
     * Generates and parses an RTM2 token whose uncompressed payload exceeds the initial buffer capacity.
     */
    @Test
    public void largeRtm2PermissionPayload() throws Exception {
        List<String> resources = new ArrayList<>();
        for (int i = 0; i < 160; i++) {
            resources.add(String.format("resource-%04d", i));
        }

        AccessToken2.ServiceRtm2.Permissions permissions = new AccessToken2.ServiceRtm2.Permissions();
        permissions.add(AccessToken2.ServiceRtm2.Permissions.USERS,
                AccessToken2.ServiceRtm2.Permissions.READ, resources);
        AccessToken2.ServiceRtm2 service = new AccessToken2.ServiceRtm2(userId, permissions);
        service.addPrivilegeRtm2(AccessToken2.PrivilegeRtm2.PRIVILEGE_LOGIN, expire);

        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;
        accessToken.addService(service);

        AccessToken2 parsed = new AccessToken2();
        assertTrue(parsed.parse(accessToken.build()));
        assertTrue(parsed.verifySignature(appCertificate));
        AccessToken2.ServiceRtm2 parsedService = (AccessToken2.ServiceRtm2)
                parsed.getServices(AccessToken2.SERVICE_TYPE_RTM2).get(0);
        assertEquals(resources, parsedService.permissions.details
                .get(AccessToken2.ServiceRtm2.Permissions.USERS)
                .get(AccessToken2.ServiceRtm2.Permissions.READ));
    }

    /**
     * Sorts service types as unsigned 16-bit values before packing.
     */
    @Test
    public void buildSortsServiceTypesAsUnsignedValues() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.Service highTypeService = new AccessToken2.Service((short) 0xFFFF);
        highTypeService.privileges.put((short) 1, expire);
        accessToken.addService(highTypeService);

        AccessToken2.Service lowTypeService = new AccessToken2.Service((short) 1);
        lowTypeService.privileges.put((short) 1, expire);
        accessToken.addService(lowTypeService);

        byte[] tokenData = Utils.decompress(Utils.base64Decode(accessToken.build().substring(Utils.VERSION_LENGTH)));
        ByteBuf tokenBuffer = new ByteBuf(tokenData);
        tokenBuffer.readBytes();
        tokenBuffer.readString();
        tokenBuffer.readInt();
        tokenBuffer.readInt();
        tokenBuffer.readInt();

        assertEquals(2, tokenBuffer.readShort());
        assertEquals(1, Short.toUnsignedInt(tokenBuffer.readShort()));
        tokenBuffer.readIntMap();
        assertEquals(0xFFFF, Short.toUnsignedInt(tokenBuffer.readShort()));
    }

    /**
     * Keeps known services parsed before an unknown service type.
     */
    @Test
    public void parseUnknownServiceType() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        accessToken.addService(serviceRtc);

        AccessToken2.Service unknown = new AccessToken2.Service((short) 999);
        unknown.privileges.put((short) 1, expire);
        accessToken.addService(unknown);

        AccessToken2 parser = new AccessToken2();
        assertTrue(parser.parse(accessToken.build()));
        assertEquals(1, parser.getServices(AccessToken2.SERVICE_TYPE_RTC).size());
        assertEquals(0, parser.getServices((short) 999).size());
        assertTrue(parser.verifySignature(appCertificate));
    }

    /**
     * Stops before known services that follow an unknown service payload.
     */
    @Test
    public void parseStopsAtUnknownServiceType() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        accessToken.addService(serviceRtc);

        AccessToken2.Service unknown = new AccessToken2.Service((short) 0);
        unknown.privileges.put((short) 1, expire);
        accessToken.addService(unknown);

        AccessToken2 parser = new AccessToken2();
        assertTrue(parser.parse(accessToken.build()));
        assertEquals(0, parser.getServices(AccessToken2.SERVICE_TYPE_RTC).size());
        assertTrue(parser.verifySignature(appCertificate));
    }

    /**
     * Parses an old token and replaces services from an earlier parse.
     */
    @Test
    public void parseOldTokenAndClearPreviousServices() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtm serviceRtm = new AccessToken2.ServiceRtm(userId);
        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire);
        accessToken.addService(serviceRtm);

        AccessToken2 parser = new AccessToken2();
        assertTrue(parser.parse(accessToken.build()));
        assertEquals(1, parser.getServices(AccessToken2.SERVICE_TYPE_RTM).size());

        String oldToken = "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj";
        assertTrue(parser.parse(oldToken));
        assertEquals(1, parser.services.size());
        assertEquals(1, parser.getServices(AccessToken2.SERVICE_TYPE_RTC).size());
        assertEquals(0, parser.getServices(AccessToken2.SERVICE_TYPE_RTM).size());
        assertTrue(parser.verifySignature(appCertificate));
    }

    /**
     * Rejects signature verification before parsing or with invalid certificates.
     */
    @Test
    public void verifySignaturePreconditions() throws Exception {
        AccessToken2 parser = new AccessToken2();
        assertFalse(parser.verifySignature(appCertificate));

        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;
        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        accessToken.addService(serviceRtc);

        assertTrue(parser.parse(accessToken.build()));
        assertFalse(parser.verifySignature("invalid"));
        assertFalse(parser.verifySignature("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"));
        assertTrue(parser.verifySignature(appCertificate));

        assertFalse(parser.parse("006invalid"));
        assertFalse(parser.verifySignature(appCertificate));
        assertTrue(parser.services.isEmpty());
    }

    /**
     * Parses a legacy RTC token and verifies its fields and privileges.
     */
    @Test
    public void parse_TokenRtc() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse(
                "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj");
        assertTrue(res);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);
        assertEquals(1, accessToken.services.size());
        assertEquals(channelName, ((AccessToken2.ServiceRtc) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTC).get(0))
                .getChannelName());
        assertEquals(uid, ((AccessToken2.ServiceRtc) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTC).get(0)).getUid());
        assertEquals(expire, (int) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTC).get(0)
                .getPrivileges()
                .get(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue));
        assertEquals(0, (int) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTC).get(0)
                .getPrivileges()
                .getOrDefault(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM.intValue, 0));
    }

    /**
     * Rejects a malformed RTC token.
     */
    @Test
    public void parse_TokenRtc_error() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse("007eJxTYLC/xv0i87343FLb46KrG9gPxT+Vj8pojqvt");

        assertFalse(res);
        assertEquals("", accessToken.appId);
        assertEquals(0, accessToken.expire);
        assertEquals(0, accessToken.issueTs);
        assertEquals(0, accessToken.salt);
        assertEquals(0, accessToken.services.size());
    }

    /**
     * Parses a legacy token containing RTC and RTM services.
     */
    @Test
    public void parse_TokenRtc_Rtm_MultiService() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse(
                "007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4");
        assertTrue(res);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);
        assertEquals(2, accessToken.services.size());
        assertEquals(channelName, ((AccessToken2.ServiceRtc) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTC).get(0))
                .getChannelName());
        assertEquals(uid, ((AccessToken2.ServiceRtc) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTC).get(0)).getUid());
        assertEquals(userId, ((AccessToken2.ServiceRtm) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTM).get(0)).getUserId());
        assertEquals(expire, (int) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTC).get(0)
                .getPrivileges()
                .get(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue));
        assertEquals(expire, (int) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTC).get(0)
                .getPrivileges()
                .getOrDefault(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM.intValue, 0));
        assertEquals(expire, (int) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTM).get(0)
                .getPrivileges()
                .get(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN.intValue));
    }

    /**
     * Parses a legacy RTM token and verifies its login privilege.
     */
    @Test
    public void parse_TokenRtm() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse(
                "007eJxSYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJgZGBkYwn5OhJLW4JL60OLUIEAAA//9ZVh6A");
        assertTrue(res);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);
        assertEquals(1, accessToken.services.size());
        assertEquals(userId, ((AccessToken2.ServiceRtm) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTM).get(0)).getUserId());
        assertEquals(expire, (int) accessToken.getServices(AccessToken2.SERVICE_TYPE_RTM).get(0)
                .getPrivileges()
                .get(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN.intValue));
    }

    /**
     * Parses a Chat user token and verifies its user privilege.
     */
    @Test
    public void parse_TokenChatUser() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse(
                "007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg=");
        assertTrue(res);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);
        assertEquals(1, accessToken.services.size());
        AccessToken2.ServiceChat serviceChat = (AccessToken2.ServiceChat) accessToken
                .getServices(AccessToken2.SERVICE_TYPE_CHAT).get(0);
        assertEquals(uid, serviceChat.getUserId());
        assertEquals(expire, (int) serviceChat.getPrivileges()
                .get(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER.intValue));
    }

    /**
     * Parses a Chat application token and verifies its application privilege.
     */
    @Test
    public void parse_TokenChatApp() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse(
                "007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr");
        assertTrue(res);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);
        assertEquals(1, accessToken.services.size());
        AccessToken2.ServiceChat serviceChat = (AccessToken2.ServiceChat) accessToken
                .getServices(AccessToken2.SERVICE_TYPE_CHAT).get(0);
        assertEquals("", serviceChat.getUserId());
        assertEquals(expire, (int) serviceChat.getPrivileges()
                .get(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_APP.intValue));
    }

    /**
     * Converts numeric user IDs to their token representation.
     */
    @Test
    public void getUidStr() {
        assertEquals("", AccessToken2.getUidStr(0));
        assertEquals("123", AccessToken2.getUidStr(123));
    }
}
