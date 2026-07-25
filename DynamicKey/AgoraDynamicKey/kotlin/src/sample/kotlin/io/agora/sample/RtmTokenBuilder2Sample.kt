package io.agora.sample

import io.agora.media.AccessToken2
import io.agora.media.RtmTokenBuilder2

/** Demonstrates RTM and RTM2 Token007 generation. */
object RtmTokenBuilder2Sample {
    /** Generates and prints RTM and RTM2 sample tokens. */
    @JvmStatic
    fun main(args: Array<String>) {
        val appId = System.getenv("AGORA_APP_ID")
        val appCertificate = System.getenv("AGORA_APP_CERTIFICATE")
        if (appId.isNullOrEmpty() || appCertificate.isNullOrEmpty()) {
            println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
            return
        }

        val builder = RtmTokenBuilder2()
        println("RTM token: ${builder.buildToken(appId, appCertificate, USER_ID, EXPIRE)}")

        val permissions = AccessToken2.ServiceRtm2.Permissions()
        permissions.add(
            AccessToken2.ServiceRtm2.Permissions.MESSAGE_CHANNELS,
            AccessToken2.ServiceRtm2.Permissions.READ,
            listOf("message-channel")
        )
        println(
            "RTM2 token: ${builder.buildTokenWithPermissions(appId, appCertificate, USER_ID, permissions, EXPIRE)}"
        )
    }

    private const val USER_ID = "2882341273"
    private const val EXPIRE = 600
}
