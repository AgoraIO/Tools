package io.agora.sample

import io.agora.media.RtcTokenBuilder2

/** Demonstrates RTC Token007 generation with UID and user account identities. */
object RtcTokenBuilder2Sample {
    // Need to set environment variable AGORA_APP_ID
    private val appId = System.getenv("AGORA_APP_ID")

    // Need to set environment variable AGORA_APP_CERTIFICATE
    private val appCertificate = System.getenv("AGORA_APP_CERTIFICATE")

    private const val channelName = "7d72365eb983485397e3e3f9d460bdda"
    private const val account = "2082341273"
    private const val uid = 2082341273
    private const val tokenExpirationInSeconds = 3600
    private const val privilegeExpirationInSeconds = 3600
    private const val joinChannelPrivilegeExpireInSeconds = 3600
    private const val pubAudioPrivilegeExpireInSeconds = 3600
    private const val pubVideoPrivilegeExpireInSeconds = 3600
    private const val pubDataStreamPrivilegeExpireInSeconds = 3600

    /** Generates and prints RTC sample tokens using environment-provided credentials. */
    @JvmStatic
    fun main(args: Array<String>) {
        println("App Id: $appId")
        println("App Certificate: $appCertificate")
        if (appId.isNullOrEmpty() || appCertificate.isNullOrEmpty()) {
            println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
            return
        }

        val tokenBuilder = RtcTokenBuilder2()
        var result = tokenBuilder.buildTokenWithUid(
            appId, appCertificate, channelName, uid, RtcTokenBuilder2.Role.ROLE_PUBLISHER,
            tokenExpirationInSeconds, privilegeExpirationInSeconds
        )
        println("Token with uid: $result")

        result = tokenBuilder.buildTokenWithUserAccount(
            appId, appCertificate, channelName, account,
            RtcTokenBuilder2.Role.ROLE_PUBLISHER,
            tokenExpirationInSeconds, privilegeExpirationInSeconds
        )
        println("Token with account: $result")

        result = tokenBuilder.buildTokenWithUid(
            appId, appCertificate, channelName, uid, tokenExpirationInSeconds,
            joinChannelPrivilegeExpireInSeconds, pubAudioPrivilegeExpireInSeconds,
            pubVideoPrivilegeExpireInSeconds,
            pubDataStreamPrivilegeExpireInSeconds
        )
        println("Token with uid and privilege: $result")

        result = tokenBuilder.buildTokenWithUserAccount(
            appId, appCertificate, channelName, account,
            tokenExpirationInSeconds,
            joinChannelPrivilegeExpireInSeconds, pubAudioPrivilegeExpireInSeconds,
            pubVideoPrivilegeExpireInSeconds, pubDataStreamPrivilegeExpireInSeconds
        )
        println("Token with account and privilege: $result")
    }
}
