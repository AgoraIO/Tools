export namespace ApaasTokenBuilder {
    /**
     * build user room token
     * @param appId             The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate    Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param roomUuid          The room's id, must be unique.
     * @param userUuid          The user's id, must be unique.
     * @param role              The user's role.
     * @param expire            represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The user room token.
     */
    export function buildRoomUserToken(
        appId: string,
        appCertificate: string,
        roomUuid: string,
        userUuid: string | number,
        role: number,
        expire: number
    ): string

    /**
     * build user token
     * @param appId             The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate    Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param userUuid          The user's id, must be unique.
     * @param expire            represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The user token.
     */
    export function buildUserToken(
        appId: string,
        appCertificate: string,
        userUuid: string | number,
        expire: number
    ): string

    /**
     * build app token
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The app token.
     */
    export function buildAppToken(appId: string, appCertificate: string, expire: number): string
}

export namespace ChatTokenBuilder {
    /**
     * Build the Chat user token.
     *
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from
     * Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     * the Agora Dashboard. See Get an App Certificate.
     * @param userUuid The user's id, must be unique.
     * @param expire represented by the number of seconds elapsed since now. If, for example, you want to access the
     * Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The chat user token.
     */
    export function buildUserToken(
        appId: string,
        appCertificate: string,
        userId: string | number,
        expire: number
    ): string

    /**
     * Build the Chat App token.
     *
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from
     * Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     * the Agora Dashboard. See Get an App Certificate.
     * @param expire represented by the number of seconds elapsed since now. If, for example, you want to access the
     * Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The chat App token.
     */
    export function buildAppToken(appId: string, appCertificate: string, expire: number): string
}

export namespace EducationTokenBuilder {
    /**
     * build user room token
     * @param appId             The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate    Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param roomUuid          The room's id, must be unique.
     * @param userUuid          The user's id, must be unique.
     * @param role              The user's role.
     * @param expire            represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The user room token.
     */
    export function buildRoomUserToken(
        appId: string,
        appCertificate: string,
        roomUuid: string,
        userUuid: string | number,
        role: number,
        expire: number
    ): string

    /**
     * build user token
     * @param appId             The App ID issued to you by Agora. Apply for a new App ID from
     *                          Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate    Certificate of the application that you registered in
     *                          the Agora Dashboard. See Get an App Certificate.
     * @param userUuid          The user's id, must be unique.
     * @param expire            represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                          Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The user token.
     */
    export function buildUserToken(
        appId: string,
        appCertificate: string,
        userUuid: string | number,
        expire: number
    ): string

    /**
     * build app token
     * @param appId          The App ID issued to you by Agora. Apply for a new App ID from
     *                       Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     *                       the Agora Dashboard. See Get an App Certificate.
     * @param expire         represented by the number of seconds elapsed since now. If, for example, you want to access the
     *                       Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The app token.
     */
    export function buildAppToken(appId: string, appCertificate: string, expire: number): string
}

export namespace FpaTokenBuilder {
    /**
     * Build the FPA token.
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from
     * Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     * the Agora Dashboard. See Get an App Certificate.
     * @return The FPA token.
     */
    export function buildToken(appId: string, appCertificate: string): string
}

export namespace RtcRole {
    export const PUBLISHER: number
    export const SUBSCRIBER: number
}

export namespace RtcTokenBuilder {
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
    export function buildTokenWithUid(
        appId: string,
        appCertificate: string,
        channelName: string,
        uid: string | number,
        role: number,
        tokenExpire: number,
        privilegeExpire: number
    ): string

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
    export function buildTokenWithUserAccount(
        appId: string,
        appCertificate: string,
        channelName: string,
        account: string | number,
        role: number,
        tokenExpire: number,
        privilegeExpire: number
    ): string

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
    export function buildTokenWithUidAndPrivilege(
        appId: string,
        appCertificate: string,
        channelName: string,
        uid: string | number,
        tokenExpire: number,
        joinChannelPrivilegeExpire: number,
        pubAudioPrivilegeExpire: number,
        pubVideoPrivilegeExpire: number,
        pubDataStreamPrivilegeExpire: number
    ): string

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
    export function BuildTokenWithUserAccountAndPrivilege(
        appId: string,
        appCertificate: string,
        channelName: string,
        account: string | number,
        tokenExpire: number,
        joinChannelPrivilegeExpire: number,
        pubAudioPrivilegeExpire: number,
        pubVideoPrivilegeExpire: number,
        pubDataStreamPrivilegeExpire: number
    ): string

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
    export function buildTokenWithRtm(
        appId: string,
        appCertificate: string,
        channelName: string,
        account: string | number,
        role: number,
        tokenExpire: number,
        privilegeExpire: number
    ): string

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
     * @param rtmUserId: The RTM user's account, max length is 255 Bytes.
     * @param rtmTokenExpire: represented by the number of seconds elapsed since now. If, for example,
     * you want to access the Agora Service within 10 minutes after the token is generated, set rtmTokenExpire as 600(seconds).
     * * @return The RTC and RTM Token.
     */
    export function buildTokenWithRtm2(
        appId: string,
        appCertificate: string,
        channelName: string,
        rtcAccount: string | number,
        rtcRole: number,
        rtcTokenExpire: number,
        joinChannelPrivilegeExpire: number,
        pubAudioPrivilegeExpire: number,
        pubVideoPrivilegeExpire: number,
        pubDataStreamPrivilegeExpire: number,
        rtmUserId: string | number,
        rtmTokenExpire: number
    ): string
}

export namespace RtmTokenBuilder {
    /**
     * Build the RTM token.
     *
     * @param appId The App ID issued to you by Agora. Apply for a new App ID from
     * Agora Dashboard if it is missing from your kit. See Get an App ID.
     * @param appCertificate Certificate of the application that you registered in
     * the Agora Dashboard. See Get an App Certificate.
     * @param userId The user's account, max length is 64 Bytes.
     * @param expire represented by the number of seconds elapsed since now. If, for example, you want to access the
     * Agora Service within 10 minutes after the token is generated, set expire as 600(seconds).
     * @return The RTM token.
     */
    export function buildToken(appId: string, appCertificate: string, userId: string | number, expire: number): string
}
