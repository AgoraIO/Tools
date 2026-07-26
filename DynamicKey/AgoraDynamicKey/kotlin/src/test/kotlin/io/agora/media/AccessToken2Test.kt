package io.agora.media

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

/** Tests Token007 generation, parsing, compatibility, and signature verification. */
class AccessToken2Test {
    private val appId = "970CA35de60c44645bbae8a215061b33"
    private val appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
    private val wrongAppCertificate = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    private val channelName = "7d72365eb983485397e3e3f9d460bdda"
    private val expire = 600
    private val issueTs = 1111111
    private val salt = 1
    private val uid = "2882341273"
    private val userId = "test_user"

    /** Verifies token generation rejects an empty service list. */
    @Test
    fun buildRejectsEmptyServices() {
        val token = newToken()

        assertEquals("", token.build())
    }

    /** Verifies token generation rejects invalid application credentials. */
    @Test
    fun buildRejectsInvalidCredentials() {
        val service = AccessToken2.ServiceRtm(userId)
        service.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire)

        assertEquals("", AccessToken2("invalid", appCertificate, expire).also { it.addService(service) }.build())
        assertEquals("", AccessToken2(appId, "invalid", expire).also { it.addService(service) }.build())
    }

    /** Verifies deterministic RTC token generation against the shared cross-language fixture. */
    @Test
    fun buildRtcService() {
        val token = newToken()
        val service = AccessToken2.ServiceRtc(channelName, uid)
        service.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire)
        token.addService(service)

        assertEquals(
            "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj",
            token.build()
        )
    }

    /** Preserves duplicate service insertion order while packing service types in stable order. */
    @Test
    fun buildAndParseRepeatedServiceTypes() {
        val token = newToken()
        val rtm = AccessToken2.ServiceRtm(userId)
        rtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire + 50)
        token.addService(rtm)

        val rtc = AccessToken2.ServiceRtc(channelName, uid)
        rtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire)
        token.addService(rtc)

        val streamRtc = AccessToken2.ServiceRtc("stream-channel", "stream-user")
        streamRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire + 100)
        streamRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM, expire + 100)
        token.addService(streamRtc)

        assertEquals(rtm, token.services.first())
        assertEquals(2, token.getServices(AccessToken2.SERVICE_TYPE_RTC).size)

        val parser = AccessToken2()
        assertTrue(parser.parse(token.build()))
        assertTrue(parser.verifySignature(appCertificate))
        assertFalse(parser.verifySignature(wrongAppCertificate))
        assertEquals(3, parser.services.size)
        assertEquals(AccessToken2.SERVICE_TYPE_RTC, parser.services[0].serviceType)
        assertEquals(AccessToken2.SERVICE_TYPE_RTC, parser.services[1].serviceType)
        assertEquals(AccessToken2.SERVICE_TYPE_RTM, parser.services[2].serviceType)
        assertEquals(channelName, (parser.getServices(AccessToken2.SERVICE_TYPE_RTC)[0] as AccessToken2.ServiceRtc).channelName)
        assertEquals("stream-channel", (parser.getServices(AccessToken2.SERVICE_TYPE_RTC)[1] as AccessToken2.ServiceRtc).channelName)
    }

    /** Parses and verifies the C++ fixture containing Streaming, FCDN, and RTM2 services. */
    @Test
    fun parseExtendedServicesFromCpp() {
        val token = "007eJxTYPj86Lzdz79M25wNn/lMfvu+TkfmdpiviKvChm8ZV3SWndytwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs7P5FgCGCiYGBkYGBgRkImYAsEJ8JTCowmKeYGxmbmaYmWVoYm1iYGluapxqnGqdZppiYGSSlpCRyMRhZWBgZmxgamRuzUaSbA6gXopuToSS1uCS+tDi1iJkB4jQmoGBuanFxYnqqbiKCmcTIAIEcDMUlRamJubqJLGD1jAxsDCD9uokAO/VDvQ=="
        val parser = AccessToken2()

        assertTrue(parser.parse(token))
        assertTrue(parser.verifySignature(appCertificate))

        val streaming = parser.getServices(AccessToken2.SERVICE_TYPE_STREAMING)[0] as AccessToken2.ServiceStreaming
        assertEquals(channelName, streaming.channelName)
        assertEquals(uid, streaming.account)
        assertEquals(expire, streaming.privileges[AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_MIX_STREAM.intValue])
        assertEquals(expire, streaming.privileges[AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_RAW_STREAM.intValue])

        val fcdn = parser.getServices(AccessToken2.SERVICE_TYPE_FCDN)[0] as AccessToken2.ServiceFCdn
        assertEquals(channelName, fcdn.channelName)
        assertEquals(uid, fcdn.account)
        assertEquals(expire, fcdn.privileges[AccessToken2.PrivilegeFCdn.PRIVILEGE_PUBLISH.intValue])
        assertEquals(expire, fcdn.privileges[AccessToken2.PrivilegeFCdn.PRIVILEGE_PLAY.intValue])

        val rtm2 = parser.getServices(AccessToken2.SERVICE_TYPE_RTM2)[0] as AccessToken2.ServiceRtm2
        assertEquals(userId, rtm2.userId)
        assertEquals(listOf("message-a", "message-b"), rtm2.permissions.details[AccessToken2.ServiceRtm2.Permissions.MESSAGE_CHANNELS]?.get(AccessToken2.ServiceRtm2.Permissions.READ))
        assertEquals(listOf("stream-a"), rtm2.permissions.details[AccessToken2.ServiceRtm2.Permissions.STREAM_CHANNELS]?.get(AccessToken2.ServiceRtm2.Permissions.WRITE))
        assertEquals(listOf("user-a"), rtm2.permissions.details[AccessToken2.ServiceRtm2.Permissions.USERS]?.get(AccessToken2.ServiceRtm2.Permissions.READ))
    }

    /** Round-trips the fixed services not covered by the cross-language RTC fixture. */
    @Test
    fun roundTripsFpaChatAndApaasServices() {
        val token = newToken()
        val fpa = AccessToken2.ServiceFpa()
        fpa.addPrivilegeFpa(AccessToken2.PrivilegeFpa.PRIVILEGE_LOGIN, expire)
        token.addService(fpa)

        val chat = AccessToken2.ServiceChat(userId)
        chat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER, expire)
        token.addService(chat)

        val apaas = AccessToken2.ServiceApaas("room-id", "user-id", 2)
        apaas.addPrivilegeApaas(AccessToken2.PrivilegeApaas.PRIVILEGE_ROOM_USER, expire)
        token.addService(apaas)

        val parser = AccessToken2()
        assertTrue(parser.parse(token.build()))
        assertTrue(parser.verifySignature(appCertificate))
        assertEquals(expire, parser.getServices(AccessToken2.SERVICE_TYPE_FPA)[0].privileges[AccessToken2.PrivilegeFpa.PRIVILEGE_LOGIN.intValue])
        assertEquals(userId, (parser.getServices(AccessToken2.SERVICE_TYPE_CHAT)[0] as AccessToken2.ServiceChat).userId)
        val parsedApaas = parser.getServices(AccessToken2.SERVICE_TYPE_APAAS)[0] as AccessToken2.ServiceApaas
        assertEquals("room-id", parsedApaas.roomUuid)
        assertEquals("user-id", parsedApaas.userUuid)
        assertEquals(2.toShort(), parsedApaas.role)
    }

    /** Verifies Streaming and FCDN UID conversion and deterministic C++ compatibility. */
    @Test
    fun extendedServiceNumericUidConversion() {
        val token = newToken()
        val streamingUid = AccessToken2.ServiceStreaming(channelName, 2882341273L)
        streamingUid.addPrivilegeStreaming(AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_MIX_STREAM, expire)
        token.addService(streamingUid)
        val streamingWildcard = AccessToken2.ServiceStreaming(channelName, 0L)
        streamingWildcard.addPrivilegeStreaming(AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_RAW_STREAM, expire)
        token.addService(streamingWildcard)
        val streamingAccount = AccessToken2.ServiceStreaming(channelName, "stream-account")
        streamingAccount.addPrivilegeStreaming(AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_MIX_STREAM, expire)
        streamingAccount.addPrivilegeStreaming(AccessToken2.PrivilegeStreaming.PRIVILEGE_PUBLISH_RAW_STREAM, expire)
        token.addService(streamingAccount)

        val fcdnUid = AccessToken2.ServiceFCdn(channelName, 2882341273L)
        fcdnUid.addPrivilegeFCdn(AccessToken2.PrivilegeFCdn.PRIVILEGE_PUBLISH, expire)
        token.addService(fcdnUid)
        val fcdnWildcard = AccessToken2.ServiceFCdn(channelName, 0L)
        fcdnWildcard.addPrivilegeFCdn(AccessToken2.PrivilegeFCdn.PRIVILEGE_PLAY, expire)
        token.addService(fcdnWildcard)
        val fcdnAccount = AccessToken2.ServiceFCdn(channelName, "fcdn-account")
        fcdnAccount.addPrivilegeFCdn(AccessToken2.PrivilegeFCdn.PRIVILEGE_PUBLISH, expire)
        fcdnAccount.addPrivilegeFCdn(AccessToken2.PrivilegeFCdn.PRIVILEGE_PLAY, expire)
        token.addService(fcdnAccount)

        val encoded = token.build()
        assertEquals(
            "007eJxTYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwA2lGMF+BwTzF3MjYzDQ1ydLC2MTC1NjSPNU41TjNMsXEzCApJSWRi8HIwsLI2MTQyNwYpI+JSH0MQFuYoLYQq4ePobikKDUxVzcxOTm/NK+EjUx3spHkTjaS3cnDkJackgdzJQBJb19X",
            encoded
        )

        val parser = AccessToken2()
        assertTrue(parser.parse(encoded))
        assertTrue(parser.verifySignature(appCertificate))
        assertEquals(listOf("2882341273", "", "stream-account"), parser.getServices(AccessToken2.SERVICE_TYPE_STREAMING).map { (it as AccessToken2.ServiceStreaming).account })
        assertEquals(listOf("2882341273", "", "fcdn-account"), parser.getServices(AccessToken2.SERVICE_TYPE_FCDN).map { (it as AccessToken2.ServiceFCdn).account })
    }

    /** Generates and parses an RTM2 payload larger than the initial serialization buffer. */
    @Test
    fun largeRtm2PermissionPayload() {
        val resources = List(160) { "resource-%04d".format(it) }
        val permissions = AccessToken2.ServiceRtm2.Permissions()
        permissions.add(AccessToken2.ServiceRtm2.Permissions.USERS, AccessToken2.ServiceRtm2.Permissions.READ, resources)
        val service = AccessToken2.ServiceRtm2(userId, permissions)
        service.addPrivilegeRtm2(AccessToken2.PrivilegeRtm2.PRIVILEGE_LOGIN, expire)
        val token = newToken()
        token.addService(service)

        val parser = AccessToken2()
        assertTrue(parser.parse(token.build()))
        assertTrue(parser.verifySignature(appCertificate))
        val parsed = parser.getServices(AccessToken2.SERVICE_TYPE_RTM2)[0] as AccessToken2.ServiceRtm2
        assertEquals(resources, parsed.permissions.details[AccessToken2.ServiceRtm2.Permissions.USERS]?.get(AccessToken2.ServiceRtm2.Permissions.READ))
    }

    /** Keeps known services parsed before an unknown service type. */
    @Test
    fun parseKeepsServicesBeforeUnknownType() {
        val token = newToken()
        val rtc = AccessToken2.ServiceRtc(channelName, uid)
        rtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire)
        token.addService(rtc)
        token.addService(AccessToken2.Service(999).also { it.privileges[1] = expire })

        val parser = AccessToken2()
        assertTrue(parser.parse(token.build()))
        assertEquals(1, parser.getServices(AccessToken2.SERVICE_TYPE_RTC).size)
        assertTrue(parser.verifySignature(appCertificate))
    }

    /** Stops before known services that follow an unknown service payload. */
    @Test
    fun parseStopsAtUnknownServiceType() {
        val token = newToken()
        token.addService(AccessToken2.Service(0).also { it.privileges[1] = expire })
        val rtc = AccessToken2.ServiceRtc(channelName, uid)
        rtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire)
        token.addService(rtc)

        val parser = AccessToken2()
        assertTrue(parser.parse(token.build()))
        assertTrue(parser.services.isEmpty())
        assertTrue(parser.verifySignature(appCertificate))
    }

    /** Parses a legacy RTC token and replaces services from an earlier parse. */
    @Test
    fun parseOldTokenAndClearPreviousServices() {
        val token = newToken()
        val rtm = AccessToken2.ServiceRtm(userId)
        rtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire)
        token.addService(rtm)

        val parser = AccessToken2()
        assertTrue(parser.parse(token.build()))
        assertEquals(1, parser.getServices(AccessToken2.SERVICE_TYPE_RTM).size)

        assertTrue(parser.parse(LEGACY_RTC_TOKEN))
        assertEquals(1, parser.services.size)
        assertEquals(1, parser.getServices(AccessToken2.SERVICE_TYPE_RTC).size)
        assertTrue(parser.getServices(AccessToken2.SERVICE_TYPE_RTM).isEmpty())
        assertTrue(parser.verifySignature(appCertificate))
    }

    /** Rejects malformed tokens and prevents reuse of a previously parsed signature. */
    @Test
    fun failedParseClearsPreviousState() {
        val parser = AccessToken2()
        assertFalse(parser.verifySignature(appCertificate))
        assertFalse(parser.verifySignature(null))
        assertFalse(parser.parse(null))
        assertFalse(parser.parse(""))
        assertTrue(parser.parse(LEGACY_RTC_TOKEN))
        assertTrue(parser.verifySignature(appCertificate))

        assertFalse(parser.parse("006invalid"))
        assertFalse(parser.verifySignature(appCertificate))
        assertEquals("", parser.appId)
        assertTrue(parser.services.isEmpty())
        assertFalse(parser.parse("007eJxTYLC/xv0i87343FLb46KrG9gPxT+Vj8pojqvt"))
        assertTrue(parser.services.isEmpty())
    }

    /** Converts numeric user IDs to their unsigned token representation. */
    @Test
    fun getUidStr() {
        assertEquals("", AccessToken2.getUidStr(0))
        assertEquals("123", AccessToken2.getUidStr(123))
        assertEquals("4294967295", AccessToken2.getUidStr(-1))
    }

    /** Creates a deterministic token builder for compatibility fixtures. */
    private fun newToken(): AccessToken2 = AccessToken2(appId, appCertificate, expire).also {
        it.issueTs = issueTs
        it.salt = salt
    }

    private companion object {
        const val LEGACY_RTC_TOKEN = "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj"
    }
}
