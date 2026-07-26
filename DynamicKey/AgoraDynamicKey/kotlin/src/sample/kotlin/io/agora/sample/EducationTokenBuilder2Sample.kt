package io.agora.sample

import io.agora.media.EducationTokenBuilder2

/** Demonstrates Education Token007 generation. */
object EducationTokenBuilder2Sample {
    /** Generates and prints Education room-user, user, and application sample tokens. */
    @JvmStatic
    fun main(args: Array<String>) {
        val appId = System.getenv("AGORA_APP_ID")
        val appCertificate = System.getenv("AGORA_APP_CERTIFICATE")
        if (appId.isNullOrEmpty() || appCertificate.isNullOrEmpty()) {
            println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
            return
        }

        val builder = EducationTokenBuilder2()
        println(
            "Education room-user token: ${builder.buildRoomUserToken(appId, appCertificate, ROOM_UUID, USER_UUID, ROLE, EXPIRE)}"
        )
        println("Education user token: ${builder.buildUserToken(appId, appCertificate, USER_UUID, EXPIRE)}")
        println("Education app token: ${builder.buildAppToken(appId, appCertificate, EXPIRE)}")
    }

    private const val ROOM_UUID = "123"
    private const val USER_UUID = "2882341273"
    private const val ROLE: Short = 1
    private const val EXPIRE = 600
}
