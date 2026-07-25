package io.agora.sample

import io.agora.media.ApaasTokenBuilder

/** Demonstrates APaaS Token007 generation. */
object ApaasTokenBuilderSample {
    /** Generates and prints APaaS room-user, user, and application sample tokens. */
    @JvmStatic
    fun main(args: Array<String>) {
        val appId = System.getenv("AGORA_APP_ID")
        val appCertificate = System.getenv("AGORA_APP_CERTIFICATE")
        if (appId.isNullOrEmpty() || appCertificate.isNullOrEmpty()) {
            println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
            return
        }

        val builder = ApaasTokenBuilder()
        println(
            "APaaS room-user token: ${builder.buildRoomUserToken(appId, appCertificate, ROOM_UUID, USER_UUID, ROLE, EXPIRE)}"
        )
        println("APaaS user token: ${builder.buildUserToken(appId, appCertificate, USER_UUID, EXPIRE)}")
        println("APaaS app token: ${builder.buildAppToken(appId, appCertificate, EXPIRE)}")
    }

    private const val ROOM_UUID = "123"
    private const val USER_UUID = "2882341273"
    private const val ROLE: Short = 1
    private const val EXPIRE = 600
}
