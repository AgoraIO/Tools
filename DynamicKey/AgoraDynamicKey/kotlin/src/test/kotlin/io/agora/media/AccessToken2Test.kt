package io.agora.media

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class AccessToken2Test {
    private val appId = "970CA35de60c44645bbae8a215061b33"
    private val appCertificate = "5CFd2fd1755d40ecb72977518be15d3b"
    private val channelName = "7d72365eb983485397e3e3f9d460bdda"
    private val expire = 600
    private val issueTs = 1111111
    private val salt = 1
    private val uid = "2882341273"
    private val userId = "test_user"

    @Test
    @Throws(Exception::class)
    fun build() {
        val accessToken = AccessToken2(appId, appCertificate, expire)
        accessToken.issueTs = issueTs
        accessToken.salt = salt

        assertEquals(appCertificate, accessToken.appCert)
        assertEquals(appId, accessToken.appId)
        assertEquals(expire, accessToken.expire)
        assertEquals(issueTs, accessToken.issueTs)
        assertEquals(salt, accessToken.salt)

        val token = accessToken.build()
        assertEquals(
            "007eJxTYEiJ9+zw7Gb1viNuGtMfy3JriuZNp+1h1iLu/rOePHlS91WBwdLcwNnR2DQl1cwg2cTEzMQ0KSkx1SLRyNDUwMwwydjY/YsAQwQTAwMjAwgAAKtnGK8=",
            token
        )
    }

    @Test
    @Throws(Exception::class)
    fun build_ServiceRtc() {
        val accessToken = AccessToken2(appId, appCertificate, expire)
        accessToken.issueTs = issueTs
        accessToken.salt = salt

        val serviceRtc = AccessToken2.ServiceRtc(channelName, uid)
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire)
        accessToken.addService(serviceRtc)

        assertEquals(channelName, serviceRtc.channelName)
        assertEquals(uid, serviceRtc.uid)

        val token = accessToken.build()
        assertEquals(
            "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj",
            token
        )
    }

    @Test
    fun parse_TokenRtc() {
        val accessToken = AccessToken2()
        val res = accessToken.parse(
            "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj"
        )
        assertTrue(res)
        assertEquals(appId, accessToken.appId)
        assertEquals(expire, accessToken.expire)
        assertEquals(issueTs, accessToken.issueTs)
        assertEquals(salt, accessToken.salt)
        assertEquals(1, accessToken.services.size)
        val serviceRtc = accessToken.services[AccessToken2.SERVICE_TYPE_RTC] as AccessToken2.ServiceRtc
        assertEquals(channelName, serviceRtc.channelName)
        assertEquals(uid, serviceRtc.uid)
        assertEquals(expire.toLong(), serviceRtc.privileges[AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue]?.toLong())
    }

    @Test
    fun getUidStr() {
        assertEquals("", AccessToken2.getUidStr(0))
        assertEquals("123", AccessToken2.getUidStr(123))
    }
}
