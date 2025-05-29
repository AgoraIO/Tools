const AccessToken = require('../src/AccessToken2').AccessToken2
const ServiceRtc = require('../src/AccessToken2').ServiceRtc
const ServiceRtm = require('../src/AccessToken2').ServiceRtm

const Role = {
    /**
     * RECOMMENDED. Use this role for a voice/video call or a live broadcast, if
     * your scenario does not require authentication for
     * [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
     */
    PUBLISHER: 1,

    /**
     * Only use this role if your scenario require authentication for
     * [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication).
     *
     * @note In order for this role to take effect, please contact our support team
     * to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
     * still has the same privileges as Role_Publisher.
     */
    SUBSCRIBER: 2
}

class RtcTokenBuilder {
    /**
     * Builds an RTC token using an Integer uid.
     * @param {*} appId  The App ID issued to you by Agora.
     * @param {*} appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param {*} channelName The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
     * - The 26 lowercase English letters: a to z.
     * - The 26 uppercase English letters: A to Z.
     * - The 10 digits: 0 to 9.
     * - The space.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param {*} uid User ID. A 32-bit unsigned integer with a value ranging from 1 to (2^32-1).
     * @param {*} role See #userRole.
     * - Role.PUBLISHER; RECOMMENDED. Use this role for a voice/video call or a live broadcast.
     * - Role.SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication). In order for this role to take effect, please contact our support team to enable authentication for Co-host for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
     * @param {*} tokenExpire epresented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds)
     * @param {*} privilegeExpire represented by the number of seconds elapsed since now. If, for example, you want to enable your privilege for 10 minutes, set privilegeExpire as 600(seconds).
     * @return The RTC Token.
     */
    static buildTokenWithUid(appId, appCertificate, channelName, uid, role, tokenExpire, privilegeExpire = 0) {
        return this.buildTokenWithUserAccount(
            appId,
            appCertificate,
            channelName,
            uid,
            role,
            tokenExpire,
            privilegeExpire
        )
    }

    /**
     * Builds an RTC token with account.
     * @param {*} appId  The App ID issued to you by Agora.
     * @param {*} appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param {*} channelName The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
     * - The 26 lowercase English letters: a to z.
     * - The 26 uppercase English letters: A to Z.
     * - The 10 digits: 0 to 9.
     * - The space.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param {*} account The user account.
     * @param {*} role See #userRole.
     * - Role.PUBLISHER; RECOMMENDED. Use this role for a voice/video call or a live broadcast.
     * - Role.SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication). In order for this role to take effect, please contact our support team to enable authentication for Co-host for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
     * @param {*} tokenExpire epresented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds)
     * @param {*} privilegeExpire represented by the number of seconds elapsed since now. If, for example, you want to enable your privilege for 10 minutes, set privilegeExpire as 600(seconds).
     * @return The RTC Token.
     */
    static buildTokenWithUserAccount(
        appId,
        appCertificate,
        channelName,
        account,
        role,
        tokenExpire,
        privilegeExpire = 0
    ) {
        let token = new AccessToken(appId, appCertificate, 0, tokenExpire)

        let serviceRtc = new ServiceRtc(channelName, account)
        serviceRtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, privilegeExpire)
        if (role == Role.PUBLISHER) {
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, privilegeExpire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, privilegeExpire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, privilegeExpire)
        }
        token.add_service(serviceRtc)

        return token.build()
    }

    /**
     * Generates an RTC token with the specified privilege.
     *
     * This method supports generating a token with the following privileges:
     * - Joining an RTC channel.
     * - Publishing audio in an RTC channel.
     * - Publishing video in an RTC channel.
     * - Publishing data streams in an RTC channel.
     *
     * The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
     * enabled co-host authentication.
     *
     * A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
     * The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
     * or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
     * the respective timestamp for each privilege in your app logic. After receiving the callback, you need
     * to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
     * the channel.
     *
     * @note
     * Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
     * Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
     * When the token for joining the channel expires, the user is immediately kicked off the RTC channel
     * and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
     *
     * @param appId The App ID of your Agora project.
     * @param appCertificate The App Certificate of your Agora project.
     * @param channelName The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
     * - All lowercase English letters: a to z.
     * - All uppercase English letters: A to Z.
     * - All numeric characters: 0 to 9.
     * - The space character.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param uid The user ID. A 32-bit unsigned integer with a value range from 1 to (2^32 - 1). It must be unique. Set uid as 0, if you do not want to authenticate the user ID, that is, any uid from the app client can join the channel.
     * @param tokenExpire represented by the number of seconds elapsed since now. If, for example, you want to access the
     * Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds).
     * @param joinChannelPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to join channel and expect stay in the channel for 10 minutes, set joinChannelPrivilegeExpire as 600(seconds).
     * @param pubAudioPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to enable publish audio privilege for 10 minutes, set pubAudioPrivilegeExpire as 600(seconds).
     * @param pubVideoPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to enable publish video privilege for 10 minutes, set pubVideoPrivilegeExpire as 600(seconds).
     * @param pubDataStreamPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to enable publish data stream privilege for 10 minutes, set pubDataStreamPrivilegeExpire as 600(seconds).
     * @return The RTC Token
     */
    static buildTokenWithUidAndPrivilege(
        appId,
        appCertificate,
        channelName,
        uid,
        tokenExpire,
        joinChannelPrivilegeExpire,
        pubAudioPrivilegeExpire,
        pubVideoPrivilegeExpire,
        pubDataStreamPrivilegeExpire
    ) {
        return this.BuildTokenWithUserAccountAndPrivilege(
            appId,
            appCertificate,
            channelName,
            uid,
            tokenExpire,
            joinChannelPrivilegeExpire,
            pubAudioPrivilegeExpire,
            pubVideoPrivilegeExpire,
            pubDataStreamPrivilegeExpire
        )
    }

    /**
     * Generates an RTC token with the specified privilege.
     *
     * This method supports generating a token with the following privileges:
     * - Joining an RTC channel.
     * - Publishing audio in an RTC channel.
     * - Publishing video in an RTC channel.
     * - Publishing data streams in an RTC channel.
     *
     * The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
     * enabled co-host authentication.
     *
     * A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
     * The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
     * or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
     * the respective timestamp for each privilege in your app logic. After receiving the callback, you need
     * to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
     * the channel.
     *
     * @note
     * Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
     * Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
     * When the token for joining the channel expires, the user is immediately kicked off the RTC channel
     * and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
     *
     * @param appId The App ID of your Agora project.
     * @param appCertificate The App Certificate of your Agora project.
     * @param channelName The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
     * - All lowercase English letters: a to z.
     * - All uppercase English letters: A to Z.
     * - All numeric characters: 0 to 9.
     * - The space character.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param userAccount The user account.
     * @param tokenExpire represented by the number of seconds elapsed since now. If, for example, you want to access the
     * Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds).
     * @param joinChannelPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to join channel and expect stay in the channel for 10 minutes, set joinChannelPrivilegeExpire as 600(seconds).
     * @param pubAudioPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to enable publish audio privilege for 10 minutes, set pubAudioPrivilegeExpire as 600(seconds).
     * @param pubVideoPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to enable publish video privilege for 10 minutes, set pubVideoPrivilegeExpire as 600(seconds).
     * @param pubDataStreamPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to enable publish data stream privilege for 10 minutes, set pubDataStreamPrivilegeExpire as 600(seconds).
     * @return The RTC Token.
     */
    static BuildTokenWithUserAccountAndPrivilege(
        appId,
        appCertificate,
        channelName,
        account,
        tokenExpire,
        joinChannelPrivilegeExpire,
        pubAudioPrivilegeExpire,
        pubVideoPrivilegeExpire,
        pubDataStreamPrivilegeExpire
    ) {
        let token = new AccessToken(appId, appCertificate, 0, tokenExpire)

        let serviceRtc = new ServiceRtc(channelName, account)
        serviceRtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, joinChannelPrivilegeExpire)
        serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, pubAudioPrivilegeExpire)
        serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, pubVideoPrivilegeExpire)
        serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, pubDataStreamPrivilegeExpire)
        token.add_service(serviceRtc)

        return token.build()
    }

    /**
     * Build an RTC and RTM token with account.
     * @param {*} appId  The App ID issued to you by Agora.
     * @param {*} appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param {*} channelName The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
     * - The 26 lowercase English letters: a to z.
     * - The 26 uppercase English letters: A to Z.
     * - The 10 digits: 0 to 9.
     * - The space.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param {*} account The user account.
     * @param {*} role See #userRole.
     * - Role.PUBLISHER; RECOMMENDED. Use this role for a voice/video call or a live broadcast.
     * - Role.SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication). In order for this role to take effect, please contact our support team to enable authentication for Co-host for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
     * @param {*} tokenExpire epresented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds)
     * @param {*} privilegeExpire represented by the number of seconds elapsed since now. If, for example, you want to enable your privilege for 10 minutes, set privilegeExpire as 600(seconds).
     * @return The RTC and RTM Token.
     */
    static buildTokenWithRtm(appId, appCertificate, channelName, account, role, tokenExpire, privilegeExpire = 0) {
        let token = new AccessToken(appId, appCertificate, 0, tokenExpire)

        let serviceRtc = new ServiceRtc(channelName, account)
        serviceRtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, privilegeExpire)
        if (role == Role.PUBLISHER) {
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, privilegeExpire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, privilegeExpire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, privilegeExpire)
        }
        token.add_service(serviceRtc)

        let serviceRtm = new ServiceRtm(account)
        serviceRtm.add_privilege(ServiceRtm.kPrivilegeLogin, tokenExpire)
        token.add_service(serviceRtm)

        return token.build()
    }

    /**
     * Build an RTC and RTM token with account.
     * @param {*} appId  The App ID issued to you by Agora.
     * @param {*} appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param {*} channelName The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
     * - The 26 lowercase English letters: a to z.
     * - The 26 uppercase English letters: A to Z.
     * - The 10 digits: 0 to 9.
     * - The space.
     * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
     * @param {*} rtcAccount The RTC user's account, max length is 255 Bytes.
     * @param {*} rtcRole See #userRole.
     * - Role.PUBLISHER; RECOMMENDED. Use this role for a voice/video call or a live broadcast.
     * - Role.SUBSCRIBER: ONLY use this role if your live-broadcast scenario requires authentication for [Co-host](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication). In order for this role to take effect, please contact our support team to enable authentication for Co-host for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
     * @param {*} rtcTokenExpire epresented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set tokenExpire as 600(seconds)
     * @param {*} joinChannelPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to join channel and expect stay in the channel for 10 minutes, set joinChannelPrivilegeExpire as 600(seconds).
     * @param {*} pubAudioPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to enable publish audio privilege for 10 minutes, set pubAudioPrivilegeExpire as 600(seconds).
     * @param {*} pubVideoPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to enable publish video privilege for 10 minutes, set pubVideoPrivilegeExpire as 600(seconds).
     * @param {*} pubDataStreamPrivilegeExpire represented by the number of seconds elapsed since now.
     * If, for example, you want to enable publish data stream privilege for 10 minutes, set pubDataStreamPrivilegeExpire as 600(seconds).
     * @param {*} rtmUserId: The RTM user's account, max length is 255 Bytes.
     * @param {*} rtmTokenExpire: represented by the number of seconds elapsed since now. If, for example,
     * you want to access the Agora Service within 10 minutes after the token is generated, set rtmTokenExpire as 600(seconds).
     * * @return The RTC and RTM Token.
     */
    static buildTokenWithRtm2(
        appId,
        appCertificate,
        channelName,
        rtcAccount,
        rtcRole,
        rtcTokenExpire,
        joinChannelPrivilegeExpire,
        pubAudioPrivilegeExpire,
        pubVideoPrivilegeExpire,
        pubDataStreamPrivilegeExpire,
        rtmUserId,
        rtmTokenExpire
    ) {
        let token = new AccessToken(appId, appCertificate, 0, rtcTokenExpire)

        let serviceRtc = new ServiceRtc(channelName, rtcAccount)
        serviceRtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, joinChannelPrivilegeExpire)
        if (rtcRole == Role.PUBLISHER) {
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, pubAudioPrivilegeExpire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, pubVideoPrivilegeExpire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, pubDataStreamPrivilegeExpire)
        }
        token.add_service(serviceRtc)

        let serviceRtm = new ServiceRtm(rtmUserId)
        serviceRtm.add_privilege(ServiceRtm.kPrivilegeLogin, rtmTokenExpire)
        token.add_service(serviceRtm)

        return token.build()
    }
}

module.exports.RtcTokenBuilder = RtcTokenBuilder
module.exports.Role = Role
