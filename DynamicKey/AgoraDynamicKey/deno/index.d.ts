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
        uid: number,
        role: number,
        tokenExpire: number,
        privilegeExpire: number
    ): string

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
        account: string,
        role: number,
        tokenExpire: number,
        privilegeExpire: number
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
    export function buildToken(appId: string, appCertificate: string, userId: string, expire: number): string
}
